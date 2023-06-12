// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/src/services/ads.dart';
import 'package:mituna/src/services/sound_effect.dart';
import 'package:mituna/views/arguments/competition_finished.dart';
import 'package:mituna/views/widgets/all.dart';

import '../competition/finished.dart';
import 'finished_sprint.dart';
import 'sprint_question.dart';

class SprintScreen extends StatefulWidget {
  const SprintScreen({super.key});

  static const String route = '/sprint';

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

class _SprintScreenState extends State<SprintScreen> {
  InterstitialAd? _interstitialAd;

  late PageController pageController;

  final UserHeartsController userHeartsController = UserHeartsController();

  bool startCountdownLottie = false;
  bool stopCountdownLottie = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    loadAd();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          startCountdownLottie = true;
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    locator.get<SoundEffects>().stop();
    _interstitialAd?.dispose();
    super.dispose();
  }

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {},
            );
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (!startCountdownLottie) return const Scaffold();

    if (!stopCountdownLottie) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottiefiles/lf30_editor_uli4x0lo.json',
            onLoaded: (c) {
              Future.delayed(const Duration(seconds: 4), () {
                if (mounted) {
                  setState(() {
                    stopCountdownLottie = true;
                  });
                }
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final sprint = ref.watch(sprintProvider);
              if (sprint == null) return Container();
              final hearts = ref.watch(sprintHeartsProvider(sprint.id));
              return UserHearts(
                remainingHearts: hearts,
                controller: userHeartsController,
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final sprint = ref.watch(sprintProvider);
          final userObjRef = ref.watch(userDataProvider);
          if (sprint == null) return Container();
          return userObjRef.when(
            loading: () => Container(),
            error: (error, stackTrace) => Container(),
            data: (userObj) {
              if (userObj == null) return Container();
              return PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sprint.questionCount,
                itemBuilder: (context, index) {
                  return SprintQuestion(
                    sprint: sprint,
                    userHeartsController: userHeartsController,
                    onNext: (timePassed) async {
                      sprint.incrementTimePassed(timePassed);
                      if (sprint.finished) {
                        debugPrint('Sprint time ${sprint.sprintTime} !!!!');
                        if (sprint.isCompetition) {
                          await _interstitialAd?.show();
                          if (sprint.finishedWithSuccess) {
                            userObj.incrementTopaz(sprint.topazWon, false);
                          }
                          Navigator.of(context).pushReplacementNamed(
                            CompetitionFinished.route,
                            arguments: CompetitionFinishedArguments(
                              topazWon: sprint.topazWon,
                              hasSucceded: sprint.finishedWithSuccess,
                              competition: sprint.competition,
                              time: sprint.sprintTime,
                            ),
                          );
                        } else {
                          if (Random().nextBool()) {
                            await _interstitialAd?.show();
                          }
                          if (sprint.finishedWithSuccess) {
                            userObj.incrementTopaz(sprint.topazWon);
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => FinishedSprint(
                                hasSucceded: sprint.finishedWithSuccess,
                                topazWon: sprint.topazWon,
                                category: sprint.category,
                              ),
                            ),
                          );
                        }
                      } else {
                        sprint.next();
                        if (mounted) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
