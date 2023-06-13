import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/views/widgets/all.dart';

class CompetitionInfo extends StatelessWidget {
  const CompetitionInfo({super.key});

  static const String competitionDescription =
      'Motuna Compétition est un quiz passionnant de 10 questions qui se déroule une fois par semaine. Vous pourrez comparer votre connaissance du Congo avec les autres joueurs en temps réel. La personne qui répondra au plus de questions et en moins de temps aura un prix.';
  static const String competitionPrize = '100 unités sur n\'importe quelle réseaux congolaises (Pour les testeurs)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(
        title: TextTitleLevelOne('Motuna Compétition'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
              const Align(
                alignment: Alignment.centerLeft,
                child: TextTitleLevelTwo('Description'),
              ),
              const SizedBox(height: 10.0),
              const TextDescription(competitionDescription),
              const SizedBox(height: 15.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: TextTitleLevelTwo('Prix'),
              ),
              const SizedBox(height: 10.0),
              const TextDescription(competitionPrize)
            ],
          ),
        ),
      ),
    );
  }
}
