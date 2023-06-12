import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/services/sound_effect.dart';
import 'package:mituna/views/widgets/all.dart';

import '../home/home.dart';
import '../ranking/global_ranking.dart';
import 'sprint.dart';

class FinishedSprint extends StatefulWidget {
  final bool hasSucceded;
  final int? topazWon;
  final QuestionCategory? category;
  const FinishedSprint({
    super.key,
    required this.hasSucceded,
    this.topazWon,
    required this.category,
  });

  static const route = '/finished_sprint';

  @override
  State<FinishedSprint> createState() => _FinishedSprintState();
}

class _FinishedSprintState extends State<FinishedSprint> {
  final soundEffect = locator.get<SoundEffects>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.hasSucceded) {
        soundEffect.play(soundEffect.sprintWonId);
      } else {
        soundEffect.play(soundEffect.sprintFailedId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void newSprint([QuestionCategory? category]) {
      providerContainer.read(sprintProvider.notifier).state = Sprint(category: category);
      Navigator.of(context).pushReplacementNamed(SprintScreen.route);
    }

    void showClassment() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RankingScreen(),
        ),
      );
    }

    void goToHome() {
      Navigator.of(context).pushReplacementNamed(Home.route);
    }

    final String imageAsset = widget.hasSucceded ? 'assets/svgs/Young and happy-bro.svg' : 'assets/svgs/Missed chances-cuate.svg';

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kScaffoldHorizontalPadding),
        child: Column(
          children: [
            SvgPicture.asset(
              imageAsset,
              height: MediaQuery.of(context).size.height * .35,
            ),
            if (widget.hasSucceded)
              Text.rich(
                TextSpan(
                  text: 'Bien joué, vous avez gagné ${widget.topazWon}',
                  style: const TextStyle(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: const [
                    WidgetSpan(
                      child: TopazIcon(),
                      alignment: PlaceholderAlignment.middle,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              )
            else ...[
              const TextTitleLevelTwo('Tout le monde échoue mais la reussite vient dans la persévérance.'),
              const TextTitleLevelOne('N\'abandonne pas, Récommence!')
            ],
            const Spacer(),
            PrimaryButton(
              onPressed: () => newSprint(widget.category),
              child: const TextTitleLevelTwo(
                'Poursuivre un autre sprint',
                color: kColorBlack,
              ),
            ),
            const SizedBox(height: 15.0),
            PrimaryButton(
              onPressed: showClassment,
              child: const TextTitleLevelTwo(
                'Classement du jeu',
                color: kColorBlack,
              ),
            ),
            const SizedBox(height: 15.0),
            PrimaryButton(
              onPressed: goToHome,
              backgroundColor: kColorMarigoldYellow,
              child: const TextTitleLevelTwo(
                'Aller à l’accueil',
                color: kColorBlack,
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      )),
    );
  }
}
