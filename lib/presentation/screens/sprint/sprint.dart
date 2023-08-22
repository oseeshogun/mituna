import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/usecases/sprint.dart';
import 'package:mituna/presentation/widgets/all.dart';

import 'finished_sprint.dart';
import 'sprint_question.dart';

class SprintScreen extends HookConsumerWidget {
  SprintScreen(this.sprint, {super.key});

  final Sprint sprint;
  final sprintUsecase = SprintUsecase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hearts = ref.watch(sprintHeartsProvider(sprint.id));
    final pageController = usePageController();
    final isMounted = useIsMounted();
    final startCountdownLottie = useState(false);
    final stopCountdownLottie = useState(false);

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        startCountdownLottie.value = true;
      });
      return null;
    }, []);

    if (!startCountdownLottie.value) return const Scaffold();

    if (!stopCountdownLottie.value) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottiefiles/lf30_editor_uli4x0lo.json',
            onLoaded: (c) {
              Future.delayed(const Duration(seconds: 4), () {
                if (isMounted()) stopCountdownLottie.value = true;
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        actions: [
          UserHearts(remainingHearts: hearts),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sprint.questions.length,
        itemBuilder: (context, index) {
          return SprintQuestion(
            sprint: sprint,
            onNext: (timePassed) async {
              if (sprint.finished) {
                if (sprint.success) {
                  sprintUsecase.saveTopazForAuthenticatedUser(sprint.topazWon, sprint.time);
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => FinishedSprint(
                      hasSucceded: sprint.success,
                      topazWon: sprint.topazWon,
                      category: sprint.category,
                    ),
                  ),
                );
              } else {
                if (isMounted()) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
