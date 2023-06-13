import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/db/repositories/question.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/competition.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/src/utils/logger.dart';
import 'package:mituna/views/screens/sprint/sprint.dart';
import 'package:mituna/views/widgets/all.dart';
import 'package:upgrader/upgrader.dart';

import '../competition/claim_price.dart';
import '../competition/leaderboard.dart';
import '../others/question_contribution.dart';
import '../ranking/global_ranking.dart';
import '../settings/settings.dart';
import '../sync/sync_data.dart';
import 'competition_count_down.dart';
import 'user_gift.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription? authStateListener;
  ProviderSubscription<AsyncValue<List<RewardRecord>>>? recordsListener;
  List<QuestionCategory> visibleCategories = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final questionsRepository = (await locator.get<QuestionRepository>());

      // sync data
      if (true) {
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SyncData()));
        setState(() {});
      } else {
        debugPrint("${questionsRepository.countAll()} Questions already synced !!!!!!!!!!!!!!!!!!!!!!!!!!!");
      }

      authStateListener = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) return;
        recordsListener?.close();
        recordsListener = rewardRecorsProvider(user.uid).addListener(
          providerContainer,
          (previous, next) {
            debugPrint('${next.value?.length} records not saved !!!');
          },
          onError: (err, stack) {
            logger.e(err);
            logger.e(stack);
          },
          onDependencyMayHaveChanged: () {},
          fireImmediately: true,
        );

        // set
        final messaging = FirebaseMessaging.instance;
        messaging.subscribeToTopic('competition');

        final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

        if (currentUserUid != null) {
          messaging.subscribeToTopic(currentUserUid);
        }

        if (Platform.isIOS) {
          messaging
              .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          )
              .then((settings) {
            debugPrint('User granted permission: ${settings.authorizationStatus}');
          }).catchError((err) {
            debugPrint(err.toString());
          });
        }
      });

      for (final category in QuestionCategory.values) {
        final questionsCategoryCount = questionsRepository.countAllForCategory(category);

        if (questionsCategoryCount > 30) {
          setState(() {
            visibleCategories.add(category);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    authStateListener?.cancel();
    recordsListener?.close();
    super.dispose();
  }

  void startSprint({QuestionCategory? category, List<String>? goodResponses}) {
    providerContainer.read(sprintProvider.notifier).state = Sprint(
      category: category,
      goodAnswers: goodResponses ?? [],
    );
    Navigator.of(context).pushNamed(SprintScreen.route);
  }

  void showClassment() {
    Navigator.of(context).pushNamed(RankingScreen.route);
  }

  void claimPrice() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ClaimPrice(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const TopazIcon(),
                      const SizedBox(width: 5.0),
                      Consumer(
                        builder: (context, ref, child) {
                          return ref.watch(userDataProvider).when(
                                loading: () => TextTitleLevelTwo(0.toString()),
                                error: (e, st) => TextTitleLevelTwo(0.toString()),
                                data: (userObj) {
                                  if (userObj == null) {
                                    return TextTitleLevelTwo(0.toString());
                                  }
                                  return TextTitleLevelTwo(
                                    userObj.diamonds.toString(),
                                  );
                                },
                              );
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return ref.watch(userDataProvider).when(
                                loading: () => Container(),
                                error: (e, st) => Container(),
                                data: (userObj) {
                                  if (userObj == null) {
                                    return Container();
                                  }
                                  return UserGift(userObj);
                                },
                              );
                        },
                      ),
                      const Spacer(),
                      Consumer(
                        builder: (context, ref, child) {
                          return ref.watch(activeCompetitionProvider).when(
                                loading: () => Container(),
                                error: (err, st) => Container(),
                                data: (finishedCompetition) {
                                  final uid = FirebaseAuth.instance.currentUser?.uid;
                                  if (finishedCompetition?.winner == null) {
                                    return Container();
                                  }
                                  if (finishedCompetition?.winner != uid) {
                                    return Container();
                                  }
                                  return IconButton(
                                    onPressed: () => claimPrice(),
                                    icon: const Icon(
                                      Icons.workspace_premium_outlined,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              );
                        },
                      ),
                      Consumer(builder: (context, ref, child) {
                        return ref.watch(activeCompetitionProvider).when(
                            loading: () => Container(),
                            error: (err, st) => Container(),
                            data: (finishedCompetition) {
                              if (finishedCompetition == null) {
                                return Container();
                              }
                              if (!finishedCompetition.finished) {
                                return Container();
                              }
                              final currentDate = DateTime.now();
                              final bool isTuesday = currentDate.weekday == DateTime.tuesday;
                              return IconButton(
                                onPressed: () => Navigator.of(context).pushNamed(CompetitionLeaderBoard.route),
                                icon: CustomPaint(
                                  painter: PainterIndicator(active: isTuesday),
                                  child: const Icon(
                                    Icons.hotel_class_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            });
                      }),
                      IconButton(
                        onPressed: () => showClassment(),
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
                    child: StartPrintButton(onPressed: () => startSprint()),
                  ),
                  const SizedBox(height: 20.0),
                  const TextTitleLevelOne('Appuyez pour commencer'),
                  const SizedBox(height: 30.0),
                  const FadeAnimation(
                    delay: 3.0,
                    child: CompetitionCountDown(),
                  ),
                  const SizedBox(height: 30.0),
                  if (visibleCategories.isNotEmpty) CategoryItem(
                    category: visibleCategories.first,
                    onPressed: (goodResponses) => startSprint(
                      category: visibleCategories.first,
                      goodResponses: goodResponses,
                    ),
                  ),
                  if (visibleCategories.length > 1) Wrap(
                    children: visibleCategories.skip(1).map<Widget>((category) {
                      return Container(
                        width: MediaQuery.of(context).size.width * .45,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: CategoryItem(
                          category: category,
                          onPressed: (goodResponses) => startSprint(
                            category: category,
                            goodResponses: goodResponses,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Wrap(
                    children: extraCategories.map<Widget>((extra) {
                      return Container(
                        width: MediaQuery.of(context).size.width * .45,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: ExtraCategoryItem(
                          category: extra,
                          onPressed: () {
                            switch (extra.slug) {
                              case 'history':
                                // TODO: go to history page
                                // Navigator.of(context).pushNamed(HistoryPage.route);
                                break;
                              case 'contribution':
                                Navigator.of(context).pushNamed(QuestionContribution.route);
                                break;
                              default:
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30.0),
                  Transform.translate(
                    offset: const Offset(kScaffoldHorizontalPadding, 0),
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
      ),
    );
  }
}
