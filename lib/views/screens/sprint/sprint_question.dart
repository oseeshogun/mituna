import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/db/entities/answer.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/src/services/ads.dart';
import 'package:mituna/src/services/sound_effect.dart';
import 'package:mituna/views/widgets/all.dart';
import 'package:mituna/views/widgets/question_counter/question_counter_controller.dart';
import 'package:vibration/vibration.dart';

import '../lost_heart/lost_heart.dart';

class SprintQuestion extends StatefulWidget {
  const SprintQuestion({
    Key? key,
    required this.sprint,
    required this.onNext,
    this.userHeartsController,
  }) : super(key: key);

  final Sprint sprint;
  final Future<void> Function(int timePassed)? onNext;
  final UserHeartsController? userHeartsController;

  @override
  State<SprintQuestion> createState() => _SprintQuestionState();
}

class _SprintQuestionState extends State<SprintQuestion> {
  Answer? selectedAnswer;
  int timePassed = 0;
  final questionCounterController = QuestionCounterController();

  final soundEffect = locator.get<SoundEffects>();

  bool blinking = false;
  bool answered = false;

  BannerAd? _ad;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          debugPrint('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose();

    super.dispose();
  }

  final Widget correctIcon = Image.asset(
    'assets/icons/icons8-checkmark-48.png',
    height: 30.0,
    width: 30.0,
  );

  final Widget incorrectIcon = Image.asset(
    'assets/icons/icons8-cancel-50.png',
    height: 30.0,
    width: 30.0,
  );

  Future<void> decrementHearts() async {
    widget.sprint.failed();
    widget.userHeartsController?.animate();
    if ((await Vibration.hasVibrator()) == true) {
      Vibration.vibrate();
    }
  }

  Future<void> badAnswer(UserObject userObject, BuildContext context) async {
    final remainingHearts = widget.sprint.hearts - 1;
    if (userObject.isShowLostHeartScreenAllowed && remainingHearts >= 0) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => LostHeart(remainingHearts: remainingHearts),
        ),
      );
    }
    decrementHearts();
    // show good answer
    setState(() => (blinking = true));
    await Future.delayed(const Duration(milliseconds: 1500));
    questionCounterController.stop();
    soundEffect.play(soundEffect.badAnswerId);
  }

  void goodAnswer(UserObject userObject) {
    final question = widget.sprint.question;
    questionCounterController.stop();
    soundEffect.play(soundEffect.goodAnswerId);
    userObject.saveGoodResponse(question.id);
  }

  void nextStep() => widget.onNext?.call(timePassed);

  Future<void> onTimeStopped(int elapsed, UserObject userObject) async {
    widget.sprint.timeElapsed(elapsed, selectedAnswer?.isCorrect ?? false);
    final userDidNotAnswer = selectedAnswer == null;
    if (userDidNotAnswer) decrementHearts();

    Future.delayed(const Duration(seconds: 2), nextStep);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: FadeAnimation(
                  delay: 1.0,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final userObjRef = ref.watch(userDataProvider);
                      return userObjRef.when(
                        loading: () => Container(),
                        error: (error, stackTrace) => Container(),
                        data: (userObj) {
                          if (userObj == null) return Container();
                          return QuestionCounter(
                            controller: questionCounterController,
                            count: widget.sprint.secondsPerQuestion,
                            onEnd: (elapsed) => onTimeStopped(elapsed, userObj),
                            onTick: (value) {
                              timePassed = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Align(
                alignment: Alignment.centerLeft,
                child: FadeAnimation(
                  delay: 1.1,
                  child: TextDescription(
                    'Question ${widget.sprint.questionOrder} sur ${widget.sprint.questionCount}',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: FadeAnimation(
                  delay: 1.2,
                  child: TextTitleLevelOne(
                    widget.sprint.question.text,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              if (widget.sprint.question.isByChoice || widget.sprint.question.isByTrueOrFalse) ...resultByChoices(),
            ],
          ),
        ),
        if (_ad != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: _ad!.size.width.toDouble(),
              height: 72.0,
              alignment: Alignment.center,
              child: AdWidget(ad: _ad!),
            ),
          ),
      ],
    );
  }

  List<Widget> resultByChoices() {
    return widget.sprint.question.answers.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final answer = entry.value;
      return BlinkingAnimation(
        blinking: blinking && answer.isCorrect,
        builder: (BuildContext context, bool animatedBlinking) {
          return FadeAnimation(
            delay: 1.3 + (index / 10),
            child: Consumer(
              builder: (context, ref, child) {
                final userObjRef = ref.watch(userDataProvider);
                return userObjRef.when(
                  loading: () => Container(),
                  error: (error, stackTrace) => Container(),
                  data: (userObj) {
                    if (userObj == null) return Container();
                    return PrimaryRadioButton<int>(
                      value: answer.id,
                      forceSelected: animatedBlinking,
                      groupValue: selectedAnswer?.id,
                      onChanged: (value) async {
                        if (answered) return;
                        questionCounterController.pause();
                        setState(() => (answered = true));
                        final answerExists = widget.sprint.question.answers.any((element) => element.id == value);
                        if (!answerExists) {
                          return await badAnswer(userObj, context);
                        }

                        final answerValue = widget.sprint.question.answers.firstWhere((element) => element.id == value);
                        setState(() {
                          selectedAnswer = answerValue;
                        });
                        if (!answer.isCorrect) {
                          await badAnswer(userObj, context);
                        } else {
                          goodAnswer(userObj);
                        }
                      },
                      text: answer.value,
                      selectedFillColor: answer.isCorrect ? kColorYellow : kColorOrange,
                      selectedBorderColor: answer.isCorrect ? kColorYellow : kColorOrange,
                      selectRadioIcon: answer.isCorrect ? correctIcon : incorrectIcon,
                    );
                  },
                );
              },
            ),
          );
        },
      );
    }).toList();
  }
}
