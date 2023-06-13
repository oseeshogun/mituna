import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/utils/logger.dart';
import 'package:mituna/views/screens/all.dart';
import 'package:mituna/views/widgets/all.dart';

class WaitForCompetition extends StatefulWidget {
  const WaitForCompetition({super.key});

  @override
  State<WaitForCompetition> createState() => _WaitForCompetitionState();
}

class _WaitForCompetitionState extends State<WaitForCompetition> {
  StreamSubscription<Competition?>? competitionListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      competitionProvider.addListener(providerContainer, (previous, next) {
        final competition = next.value;
        if (competition == null) return;
          if (competition.started) {
            providerContainer.read(sprintProvider.notifier).state = Sprint(
              category: null,
              competition: competition,
              questionCount: competition.questions.length,
            );
            Navigator.of(context).pushReplacementNamed(SprintScreen.route);
          }
       }, onError: (err, stack){
        logger.e(err);
        logger.e(stack);
      }, onDependencyMayHaveChanged: () {}, fireImmediately: true,);
    });
  }

  @override
  void dispose() {
    competitionListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(
        title: TextTitleLevelOne('Motuna Compétition'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svgs/Business competition-rafiki.svg',
              height: MediaQuery.of(context).size.height * .4,
            ),
            const SizedBox(height: 10.0),
            const TextTitleLevelTwo('La compétition commence à'),
            const SizedBox(height: 10.0),
            const Text(
              '13h05\'',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36.0,
                color: kColorYellow,
              ),
            ),
            const Spacer(),
            Column(
              children: const [
                TextDescription(
                  'Rester sur cette page pour ne pas manquer la compétition. Vous devez obligatoirement être sur cette page à 13h05 pour participer à la compétition.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 20.0),
                Icon(Icons.warning, color: kColorYellow, size: 50.0),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
