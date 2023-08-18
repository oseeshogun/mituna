import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/preferences.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/theme/colors.dart';
import 'package:mituna/core/theme/sizes.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/services/sound_effect.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'lost_heart.dart';
import 'question_counter.dart';

class SprintQuestion extends HookConsumerWidget {
  const SprintQuestion({
    super.key,
    required this.sprint,
    required this.onNext,
  });

  final Sprint sprint;
  final Future<void> Function(int timePassed)? onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = locator.get<SharedPreferences>();
    final soundEffect = locator.get<SoundEffects>();
    final question = useState(sprint.randomQuestion);
    final selectedAnswer = useState<AnswerData?>(null);
    final questionCounterState = useState(QuestionCounterState.running);
    final timePassed = useState(0);
    final answered = useState(false);
    final blinking = useState(false);

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

    Future<void> badAnswer() async {
      final remainingHearts = sprint.hearts;
      if (prefs.isShowLostHeartScreenAllowed && remainingHearts >= 0) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => LostHeart(remainingHearts: remainingHearts),
          ),
        );
        prefs.isShowLostHeartScreenAllowed = false;
      }
      blinking.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      if ((await Vibration.hasVibrator()) == true) {
        Vibration.vibrate();
      }
      soundEffect.play(soundEffect.badAnswerId);
    }

    Future<void> onStoppedQuestion() async {
      if (questionCounterState.value == QuestionCounterState.stopped) return;
      sprint.answer(question.value, selectedAnswer.value, timePassed.value);
      ref.watch(sprintHeartsProvider(sprint.id).notifier).state = sprint.hearts;
      final isCorrect = selectedAnswer.value?.isCorrect == true;
      if (!isCorrect) {
        await badAnswer();
      } else {
        soundEffect.play(soundEffect.goodAnswerId);
      }
      questionCounterState.value = QuestionCounterState.stopped;

      Future.delayed(const Duration(seconds: 2), () => onNext?.call(timePassed.value));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: FadeAnimation(
                  delay: 1.0,
                  child: QuestionCounter(
                    state: questionCounterState,
                    count: sprint.secondsPerQuestion,
                    onEnd: () => onStoppedQuestion(),
                    onTick: (value) => (timePassed.value = value),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Align(
                alignment: Alignment.centerLeft,
                child: FadeAnimation(
                  delay: 1.1,
                  child: TextDescription(
                    'Question ${sprint.questionOrder} sur ${sprint.questionCount}',
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
                    question.value.question.content,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              ...question.value.answers.asMap().entries.map<Widget>((entry) {
                final index = entry.key;
                final answer = entry.value;
                return BlinkingAnimation(
                  blinking: blinking.value && answer.isCorrect,
                  builder: (context, animatedBlinking) {
                    return FadeAnimation(
                      delay: 1.3 + (index / 10),
                      child: PrimaryRadioButton<AnswerData>(
                        value: answer,
                        forceSelected: animatedBlinking,
                        groupValue: selectedAnswer.value,
                        onChanged: (value) async {
                          if (answered.value) return;
                          questionCounterState.value = QuestionCounterState.paused;
                          answered.value = true;
                          final answerExists = question.value.answers.any((element) => element == value);
                          if (!answerExists) {
                            return await onStoppedQuestion();
                          }

                          selectedAnswer.value = value;

                          onStoppedQuestion();
                        },
                        text: answer.value,
                        selectedFillColor: answer.isCorrect ? AppColors.kColorYellow : AppColors.kColorOrange,
                        selectedBorderColor: answer.isCorrect ? AppColors.kColorYellow : AppColors.kColorOrange,
                        selectRadioIcon: answer.isCorrect ? correctIcon : incorrectIcon,
                      ),
                    );
                  },
                );
              }).toList()
            ],
          ),
        )
      ],
    );
  }
}
