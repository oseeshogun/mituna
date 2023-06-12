import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/providers/competition.dart';
import 'package:mituna/views/arguments/competition_finished.dart';
import 'package:mituna/views/widgets/all.dart';

import 'leaderboard.dart';

class CompetitionFinished extends StatefulWidget {
  const CompetitionFinished({super.key});

  static const String route = 'CompetitionFinished';

  @override
  State<CompetitionFinished> createState() => _CompetitionFinishedState();
}

class _CompetitionFinishedState extends State<CompetitionFinished> {
  bool competitionRecorded = false;
  bool competitionRecording = false;
  bool competitionRecordFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // save competition record
      saveCompetitionRecord();
    });
  }

  saveCompetitionRecord() {
    if (competitionRecorded || competitionRecording) return;
    if (mounted) {
      setState(() {
        competitionRecording = true;
        competitionRecordFailed = false;
      });
    }
    final args = ModalRoute.of(context)!.settings.arguments as CompetitionFinishedArguments;
    locator.get<CompetitionRepository>().recordCompetitionReward(args).then((_) {
      if (mounted) {
        setState(() {
          competitionRecorded = true;
          competitionRecordFailed = false;
        });
      }
    }).catchError((error) {
      debugPrint(error.toString());
      if (mounted) {
        setState(() {
          competitionRecordFailed = true;
          competitionRecorded = false;
        });
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          competitionRecording = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CompetitionFinishedArguments;

    competitionLeaderBoard() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CompetitionLeaderBoard(),
        ),
      );
    }

    return Scaffold(
      appBar: const PrimaryAppBar(
        title: TextTitleLevelOne('Motuna Compétition'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const SizedBox(
              width: double.infinity,
              child: ElevatedContainer(
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
            SvgPicture.asset(
              'assets/svgs/Hidden person-rafiki.svg',
              height: 200.0,
            ),
            const SizedBox(height: 20.0),
            if (competitionRecording) ...[
              const TextTitleLevelTwo('Veuillez patientez pendant que nous sauvegardons votre score pour cette compétition...'),
            ] else if (competitionRecordFailed) ...[
              Column(
                children: [
                  const TextTitleLevelTwo("Désolé, nous n'avons pas pu enregistrer votre score."),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
                    child: PrimaryButton(
                      backgroundColor: Colors.white,
                      child: const TextTitleLevelOne(
                        'Réessayer',
                        color: kColorBlueRibbon,
                      ),
                      onPressed: () => saveCompetitionRecord(),
                    ),
                  )
                ],
              ),
            ] else if (competitionRecorded) ...[
              Consumer(
                child: const TextTitleLevelTwo('Le résultat sera disponible quand tout le monde aura fini.'),
                builder: (context, ref, child) {
                  final defaultWidget = child ?? Container();
                  return ref.watch(activeCompetitionProvider).when(
                        loading: () => defaultWidget,
                        error: (error, stackTrace) => defaultWidget,
                        data: (competition) {
                          if (competition == null) return Container();
                          if (!competition.finished) return Container();
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => competitionLeaderBoard(),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(kColorYellow),
                                foregroundColor: MaterialStateProperty.all(kColorBlueRibbon),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    horizontal: 5.0,
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
                                '🥇 Classement',
                                color: kColorBlueRibbon,
                              ),
                            ),
                          );
                        },
                      );
                },
              ),
            ],
            const SizedBox(height: 20.0),
            if (args.hasSucceded && args.topazWon != null && args.topazWon! > 0)
              Text.rich(
                TextSpan(
                  text: 'Bien joué, vous avez gagné ${args.topazWon.toString()}',
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const WidgetSpan(
                      child: TopazIcon(),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: ' en ${args.time.toString()}s'),
                  ],
                ),
                textAlign: TextAlign.center,
              )
            else if (args.topazWon != null) ...[
              const TextTitleLevelTwo('Tout le monde échoue mais la reussite vient dans la persévérance.'),
              const TextTitleLevelOne('N\'abandonne pas !')
            ],
            const SizedBox(height: 20.0),
            if (competitionRecordFailed) ...[
              PrimaryButton(
                child: const TextTitleLevelOne('Réessayer'),
                onPressed: () => saveCompetitionRecord(),
              )
            ] else
              Lottie.asset(
                'assets/lottiefiles/lf30_editor_hbjuftkk.json',
                height: 100,
              ),
          ],
        ),
      ),
    );
  }
}
