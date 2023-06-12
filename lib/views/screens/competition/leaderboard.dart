import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/competition.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/src/utils/logger.dart';
import 'package:mituna/views/screens/ranking/top_ranking.dart';
import 'package:mituna/views/widgets/all.dart';

import '../ranking/global_ranking.dart';
import '../ranking/painters.dart';
import '../ranking/rest_of_ranking.dart';
import 'claim_price.dart';

class CompetitionLeaderBoard extends StatefulWidget {
  const CompetitionLeaderBoard({super.key});

  static const String route = 'CompetitionLeaderBoard';

  @override
  State<CompetitionLeaderBoard> createState() => _CompetitionLeaderBoardState();
}

class _CompetitionLeaderBoardState extends State<CompetitionLeaderBoard> {
  bool loading = true;
  bool failed = false;
  String? competitionId;
  ProviderSubscription<AsyncValue<Competition?>>? finishedCompetitionListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      finishedCompetitionListener = activeCompetitionProvider.addListener(
        providerContainer,
        (previous, next) {
          final competition = next.value;
          if (competition == null) return;

          loadLeaderBoard(competition.id);
          if (mounted) {
            setState(() {
              competitionId = competition.id;
            });
          }
        },
        onError: (err, stack) {
          logger.e(err);
          logger.e(stack);
        },
        onDependencyMayHaveChanged: () {},
        fireImmediately: true,
      );
    });
  }

  loadLeaderBoard(String id) {
    debugPrint('loadLeaderBoard');
    locator.get<CompetitionRepository>().getCompetitionLeaderBoard(id).then((value) {
      debugPrint(value.toString());
      setState(() {
        failed = false;
      });
    }).catchError((err) {
      debugPrint(err.toString());
      setState(() {
        failed = true;
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  CompetitionReward? getFirstRanked(List<CompetitionReward>? ranking) {
    if (ranking == null) return null;
    return ranking.isNotEmpty ? ranking.first : null;
  }

  CompetitionReward? getSecondRanked(List<CompetitionReward>? ranking) {
    if (ranking == null) return null;
    return ranking.length > 1 ? ranking[1] : null;
  }

  CompetitionReward? getThirdRanked(List<CompetitionReward>? ranking) {
    if (ranking == null) return null;
    return ranking.length > 2 ? ranking[2] : null;
  }

  @override
  void dispose() {
    finishedCompetitionListener?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void claimPrice() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const ClaimPrice(),
      ));
    }

    return Scaffold(
      appBar: const PrimaryAppBar(
        title: TextTitleLevelOne('Motuna Compétition'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
                child: const ElevatedContainer(
                  margin: EdgeInsets.zero,
                  child: Text(
                    'Classement de la compétition',
                    style: TextStyle(
                      color: kColorBlueRibbon,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    return ref.watch(activeCompetitionProvider).when(
                          loading: () => Container(),
                          error: (error, stackTrace) => Container(),
                          data: (competition) {
                            if (competition == null) {
                              return Container();
                            }
                            if (loading) {
                              return Center(
                                child: Lottie.asset(
                                  'assets/lottiefiles/lf30_editor_hkwgqg68.json',
                                ),
                              );
                            }
                            if (failed) {
                              return Column(
                                children: [
                                  const Spacer(),
                                  SvgPicture.asset(
                                    'assets/svgs/Logic-cuate.svg',
                                    height: MediaQuery.of(context).size.height * .3,
                                  ),
                                  const SizedBox(height: 30.0),
                                  if (competitionId != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
                                      child: PrimaryButton(
                                        backgroundColor: Colors.white,
                                        child: const TextTitleLevelOne(
                                          'Réessayer',
                                          color: kColorBlueRibbon,
                                        ),
                                        onPressed: () => loadLeaderBoard(competitionId!),
                                      ),
                                    ),
                                  const Spacer(),
                                ],
                              );
                            }
                            final rewards = ref.watch(competitionLeaderBoardProvider(competition.id));
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  top: MediaQuery.of(context).size.height * .06,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * .51,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildTopRanked(
                                          uid: getSecondRanked(rewards)?.uid,
                                          ref: ref,
                                          context: context,
                                          score: getSecondRanked(rewards)?.topaz.toString() ?? '',
                                          height: MediaQuery.of(context).size.height * .22,
                                          width: MediaQuery.of(context).size.width * .2,
                                          color: kColorMarigoldYellow,
                                          painter: RankSecondPainter(),
                                          position: '2',
                                          profilOffsetY: -100,
                                        ),
                                        buildTopRanked(
                                          uid: getFirstRanked(rewards)?.uid,
                                          ref: ref,
                                          context: context,
                                          score: getFirstRanked(rewards)?.topaz.toString() ?? '',
                                          height: MediaQuery.of(context).size.height * .24,
                                          width: MediaQuery.of(context).size.width * .2,
                                          color: kColorYellow,
                                          painter: RankFirstPainter(),
                                          position: '1',
                                          profilOffsetY: -120,
                                        ),
                                        buildTopRanked(
                                          uid: getThirdRanked(rewards)?.uid,
                                          ref: ref,
                                          context: context,
                                          score: getThirdRanked(rewards)?.topaz.toString() ?? '',
                                          height: MediaQuery.of(context).size.height * .20,
                                          width: MediaQuery.of(context).size.width * .2,
                                          color: kColorEarlsGreen,
                                          painter: RankThirdPainter(),
                                          position: '3',
                                          profilOffsetY: -100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height * .3),
                                    Expanded(
                                      child: ClipPath(
                                        clipper: RankingClipper(),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                            left: kScaffoldHorizontalPadding,
                                            right: kScaffoldHorizontalPadding,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              if (rewards.length <= 3) {
                                                return Container();
                                              }
                                              final sublistRewards = rewards.sublist(3, rewards.length);
                                              return ListView.builder(
                                                itemCount: sublistRewards.length,
                                                itemBuilder: (context, index) {
                                                  final reward = sublistRewards[index];
                                                  return ref.watch(specificUserDataProvider(reward.uid)).when(
                                                        loading: () => Container(),
                                                        error: (error, stackTrace) {
                                                          debugPrint(error.toString());
                                                          debugPrint(stackTrace.toString());
                                                          return Container();
                                                        },
                                                        data: (userRanked) {
                                                          if (userRanked == null) {
                                                            return Container();
                                                          }
                                                          return RankingItem(
                                                            position: index,
                                                            imageUrl: userRanked.imageUrl,
                                                            displayName: userRanked.displayName,
                                                            score: reward.topaz,
                                                            date: userRanked.lastTimeWin,
                                                          );
                                                        },
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                  },
                ),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(activeCompetitionProvider).when(
                    loading: () => Container(),
                    error: (error, stackTrace) => Container(),
                    data: (competition) {
                      if (competition == null) return Container();

                      final uid = FirebaseAuth.instance.currentUser?.uid;

                      if (uid == null) return Container();

                      if (competition.winner != uid) return Container();

                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
                          child: ElevatedButton(
                            onPressed: () => claimPrice(),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(kColorYellow),
                              foregroundColor: MaterialStateProperty.all(kColorBlueRibbon),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 15.0,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                            child: const TextTitleLevelOne(
                              '🎉 Réclamez votre prix',
                              color: kColorBlueRibbon,
                            ),
                          ),
                        ),
                      );
                    },
                  );
            },
          ),
        ],
      ),
    );
  }
}
