import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/preferences.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/ranking.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/usecases/reward.dart';
import 'package:mituna/domain/usecases/sprint.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/presentation/screens/offline_questions_load/offline_questions_load.dart';
import 'package:mituna/presentation/screens/ranking/ranking.dart';
import 'package:mituna/presentation/screens/sprint/sprint.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
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
    final firestoreAuthUserStreamProvider = ref.watch(firestoreAuthenticatedUserStreamProvider);

    startPrint([QuestionCategory? category]) async {
      sprintUsecase.start(category).then((sprint) {
        ref.watch(sprintHeartsProvider(sprint.id).notifier).state = sprint.hearts;
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SprintScreen(sprint)));
      });
    }

    useEffect(() {
      messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
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
      final authStateListener = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) return;
        userRewardsQueuedProvider(user.uid).addListener(
          locator.get<ProviderContainer>(),
          (previous, next) {
            if (next.value != null && next.value?.isNotEmpty == true) {
              for (final record in next.value!) {
                rewardsUsecase.saveRecord(record);
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

    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
            child: Column(
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
                      onPressed: () => throw UnimplementedError("Add route to settings"),
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
                CategoryItem(
                  category: QuestionCategory.values.first,
                  onPressed: () => startPrint(QuestionCategory.values.first),
                ),
                Wrap(
                  children: QuestionCategory.values.skip(1).map<Widget>((category) {
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
          ),
        ),
      ),
    );
  }
}
