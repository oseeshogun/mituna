import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/services/sound_effect.dart';
import 'package:mituna/domain/usecases/sprint.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/screens/home/home.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

import 'sprint.dart';

class FinishedSprint extends HookConsumerWidget {
  FinishedSprint({
    super.key,
    required this.hasSucceded,
    required this.category,
  });

  final bool hasSucceded;
  final QuestionCategory? category;
  final soundEffect = locator.get<SoundEffects>();
  final startSprintUsecase = StartSprintUsecase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imageAsset = hasSucceded ? 'assets/svgs/Young and happy-bro.svg' : 'assets/svgs/Missed chances-cuate.svg';

    void newSprint([QuestionCategory? category]) {
      startSprintUsecase(category).then((result) {
        result.fold((l) {
          showOkAlertDialog(context: context, message: l.message);
        }, (sprint) {
          ref.watch(sprintHeartsProvider(sprint.id).notifier).update(sprint.hearts);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SprintScreen(sprint)));
        });
      });
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (hasSucceded) {
          soundEffect.play(soundEffect.sprintWonId);
        } else {
          soundEffect.play(soundEffect.sprintFailedId);
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(AppSizes.kScaffoldHorizontalPadding),
        child: Column(
          children: [
            SvgPicture.asset(
              imageAsset,
              height: MediaQuery.of(context).size.height * .35,
            ),
            if (hasSucceded)
              Text.rich(
                TextSpan(
                  text: 'Bien joué',
                  style: const TextStyle(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              )
            else ...[
              const TextTitleLevelTwo('Tout le monde échoue mais la reussite vient dans la persévérance.'),
              const TextTitleLevelOne('N\'abandonne pas, Récommence!')
            ],
            const Spacer(),
            PrimaryButton(
              onPressed: () => newSprint(category),
              child: const TextTitleLevelTwo(
                'Poursuivre un autre sprint',
                color: AppColors.kColorBlack,
              ),
            ),
            const SizedBox(height: 15.0),
            PrimaryButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.route, (route) => false),
              backgroundColor: AppColors.kColorMarigoldYellow,
              child: const TextTitleLevelTwo(
                'Aller à l’accueil',
                color: AppColors.kColorBlack,
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      )),
    );
  }
}
