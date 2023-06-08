import 'package:mituna/src/models/competition.dart';

class CompetitionFinishedArguments {
  final int? topazWon;
  final bool hasSucceded;
  final Competition? competition;
  final int? time;

  CompetitionFinishedArguments({
    this.topazWon,
    this.hasSucceded = false,
    this.competition,
    this.time,
  });
}
