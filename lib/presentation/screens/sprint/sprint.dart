import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/services/sound_effect.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/widgets/all.dart';

import 'finished_sprint.dart';
import 'sprint_question.dart';

class SprintScreen extends HookConsumerWidget {
  SprintScreen(this.sprint, {super.key});

  final Sprint sprint;
  final soundEffect = locator.get<SoundEffects>();

  final _happyLotties = [
    'assets/lottiefiles/happy/animation_lnrqd8mz.json',
    'assets/lottiefiles/happy/animation_lnrqgndu.json',
    'assets/lottiefiles/happy/animation_lnrqqev3.json',
    'assets/lottiefiles/happy/animation_lnrqtjuo.json',
    'assets/lottiefiles/happy/animation_lnrqv2jq.json',
    'assets/lottiefiles/happy/animation_lnrqww4l.json',
  ];

  final _sadLotties = [
    'assets/lottiefiles/sad/animation_lnrqyf7x.json',
    'assets/lottiefiles/sad/animation_lnrr7zdt.json',
    'assets/lottiefiles/sad/animation_lnrra513.json',
    'assets/lottiefiles/sad/animation_lnrran7u.json',
    'assets/lottiefiles/sad/animation_lnrrc7ds.json',
    'assets/lottiefiles/sad/animation_lnrrko8w.json',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hearts = ref.watch(sprintHeartsProvider(sprint.id));
    final pageController = usePageController();
    final startCountdownLottie = useState(false);
    final stopCountdownLottie = useState(false);
    final showLottieAnimation = useState(false);
    final lottieAnimationAsset = useState<String?>(null);

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        startCountdownLottie.value = true;
      });
      return () {};
    }, []);

    if (!startCountdownLottie.value) return const Scaffold();

    if (!stopCountdownLottie.value) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottiefiles/lf30_editor_uli4x0lo.json',
            onLoaded: (c) {
              Future.delayed(const Duration(seconds: 4), () {
                if (context.mounted) stopCountdownLottie.value = true;
              });
            },
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final result =
            await showOkCancelAlertDialog(context: context, title: 'Etes-vous sûr de vouloir quitter le sprint ?', cancelLabel: 'Non', okLabel: 'Oui');
        final quit = result == OkCancelResult.ok;
        if (quit) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: PrimaryAppBar(
          actions: [
            UserHearts(remainingHearts: hearts),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sprint.questions.length,
              itemBuilder: (context, index) {
                return SprintQuestion(
                  sprint: sprint,
                  onStartAnimation: (isCorrect) async {
                    showLottieAnimation.value = true;
                    if (isCorrect) {
                      lottieAnimationAsset.value = _happyLotties[Random().nextInt(_happyLotties.length - 1)];
                    } else {
                      lottieAnimationAsset.value = _sadLotties[Random().nextInt(_sadLotties.length - 1)];
                    }
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  onNext: (timePassed) async {
                    if (sprint.finished) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => FinishedSprint(
                            hasSucceded: sprint.success,
                            category: sprint.category,
                          ),
                        ),
                      );
                    } else {
                      if (context.mounted) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                        showLottieAnimation.value = false;
                      }
                    }
                  },
                );
              },
            ),
            if (showLottieAnimation.value && lottieAnimationAsset.value != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: Lottie.asset(
                  lottieAnimationAsset.value!,
                  height: 120,
                ),
              )
          ],
        ),
      ),
    );
  }
}
