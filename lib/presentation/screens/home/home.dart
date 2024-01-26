import 'dart:io';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/ranking.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/usecases/reward.dart';
import 'package:mituna/domain/usecases/sprint.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/presentation/screens/offline_questions_load/offline_questions_load.dart';
import 'package:mituna/presentation/screens/ranking/ranking.dart';
import 'package:mituna/presentation/screens/settings/settings.dart';
import 'package:mituna/presentation/screens/sprint/sprint.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final prefs = locator.get<SharedPreferences>();

  final messaging = FirebaseMessaging.instance;

  final sprintUsecase = SprintUsecase();

  final rewardsUsecase = RewardsUsecase();

  static const String route = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingTodayQuestion = useState<bool>(false);
    final firestoreAuthUserStreamProvider = ref.watch(firestoreAuthenticatedUserStreamProvider);
    final categories = QuestionCategory.values;

    todayQuestion() {
      isLoadingTodayQuestion.value = true;
      sprintUsecase.sprintQuestionOfTheDay().then((result) {
        result.fold((l) {
          showOkAlertDialog(context: context, title: l.message);
        }, (sprint) {
          ref.watch(sprintHeartsProvider(sprint.id).notifier).update(sprint.hearts);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => SprintScreen(sprint)));
        });
        isLoadingTodayQuestion.value = false;
      });
    }

    startPrint([QuestionCategory? category]) async {
      sprintUsecase.start(category).then((sprint) {
        ref.watch(sprintHeartsProvider(sprint.id).notifier).update(sprint.hearts);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SprintScreen(sprint)));
      });
    }

    void _handleMessage(RemoteMessage message) {
      if (message.data['type'] == 'question_of_the_day' && !prefs.qotdLaunchedByNotif) {
        todayQuestion();
        prefs.qotdLaunchedByNotif = true;
      }
    }

    Future<void> setupInteractedMessage() async {
      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        _handleMessage(initialMessage);
      }

      // Also handle any interaction when the app is in the background via a
      // Stream listener
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    }

    useEffect(() {
      messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
      messaging.subscribeToTopic('question_of_the_day');
      return null;
    }, []);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!prefs.offlineQuestionsLoaded) {
          Navigator.of(context).pushNamed(OfflineQuestionsLoadScreen.route);
        }
      });
      return null;
    }, []);

    useEffect(() {
      RateMyApp rateMyApp = RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 7,
        minLaunches: 10,
        remindDays: 7,
        remindLaunches: 10,
        googlePlayIdentifier: 'deepcolt.com.mituna',
      );

      rateMyApp.init().then((_) {
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showRateDialog(
            context,
            title: 'Notez cette application',
            message:
                "Si vous aimez cette application, veuillez prendre un petit moment pour laisser un avis ! Cela nous aide vraiment et cela ne devrait pas vous prendre plus d'une minute.",
            rateButton: 'NOTEZ',
            noButton: 'NON MERCI',
            laterButton: 'PLUS TARD',
            ignoreNativeDialog: Platform.isAndroid,
            onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          );
        }
      });

      return null;
    }, []);

    useEffect(() {
      final authStateListener = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) return;
        userRewardsQueuedProvider(user.uid).addListener(
          locator.get<ProviderContainer>(),
          (previous, next) {
            if (next.value != null && next.value?.isNotEmpty == true) {
              for (final record in next.value!) {
                rewardsUsecase.saveRecord(record).then((value) {
                  value.fold((l) {
                    if (l.exception is DioException) {
                      if ((l.exception as DioException).response?.statusCode == 409) {
                        rewardsUsecase.markAsSaved(record);
                      }
                    }
                  }, (r) {
                    rewardsUsecase.markAsSaved(record);
                  });
                });
              }
            }
          },
          onError: (err, stack) {
            debugPrint(err.toString());
            debugPrint(stack.toString());
          },
          onDependencyMayHaveChanged: () {},
          fireImmediately: true,
        );
      });
      return () {
        authStateListener.cancel();
      };
    }, []);

    useEffect(() {
      setupInteractedMessage();
      return null;
    }, []);

    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: Lottie.asset(
                      'assets/lottiefiles/bells.json',
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const TopazIcon(),
                        const SizedBox(width: 5.0),
                        firestoreAuthUserStreamProvider.when(
                          loading: () => TextTitleLevelTwo(0.toString()),
                          error: (error, stackTrace) => TextTitleLevelTwo(0.toString()),
                          data: (firestoreAuthUser) => TextTitleLevelTwo(firestoreAuthUser?.diamonds.toString() ?? 0.toString()),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pushNamed(RankingScreen.route),
                          icon: const Icon(
                            Icons.bar_chart,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pushNamed(SettingsScreen.route),
                          icon: const Icon(
                            CupertinoIcons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    FadeAnimation(
                      delay: 1.0,
                      child: RunningManLottieButton(onPressed: () => startPrint()),
                    ),
                    const SizedBox(height: 20.0),
                    const TextTitleLevelOne('Appuyez pour commencer'),
                    const SizedBox(height: 30.0),
                    PrimaryButton(
                      loading: isLoadingTodayQuestion.value,
                      child: const TextTitleLevelOne(
                        '🕹️  Question du jour',
                        color: AppColors.kColorBlueRibbon,
                      ),
                      radius: 50.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 15.0,
                      ),
                      onPressed: () => todayQuestion(),
                    ),
                    const SizedBox(height: 30.0),
                    CategoryItem(
                      category: QuestionCategory.values.first,
                      onPressed: () => startPrint(QuestionCategory.values.first),
                    ),
                    Wrap(
                      children: QuestionCategory.values
                          .getRange(1, max(categories.length.isOdd ? categories.length : categories.length - 1, 1))
                          .map<Widget>((category) {
                        return Container(
                          width: MediaQuery.of(context).size.width * .45,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          child: CategoryItem(
                            category: category,
                            onPressed: () => startPrint(category),
                          ),
                        );
                      }).toList(),
                    ),
                    if (categories.length.isEven)
                      CategoryItem(
                        category: QuestionCategory.values.last,
                        onPressed: () => startPrint(QuestionCategory.values.last),
                      ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10.0),
                        SvgPicture.asset(
                          'assets/svgs/openai-white-logomark.svg',
                          height: 40.0,
                          width: 40.0,
                        ),
                        const SizedBox(width: 10.0),
                        TextTitleLevelTwo('Powered by ChatGPT API'),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Transform.translate(
                      offset: const Offset(AppSizes.kScaffoldHorizontalPadding, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/images/jaguar-42010_640.png',
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
