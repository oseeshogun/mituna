part of 'all.dart';

class RankingPeriods extends StatelessWidget {
  const RankingPeriods({
    super.key,
    required this.currentPeriod,
    required this.onPeriodChanged,
  });

  final RankingPeriod currentPeriod;
  final void Function(RankingPeriod) onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PeriodText(
            text: 'Cette semaine',
            period: RankingPeriod.week,
            currentPeriod: currentPeriod,
            onClick: onPeriodChanged,
          ),
          PeriodText(
            text: 'Ce mois',
            period: RankingPeriod.month,
            currentPeriod: currentPeriod,
            onClick: onPeriodChanged,
          ),
          PeriodText(
            text: 'Tout le temps',
            period: RankingPeriod.all,
            currentPeriod: currentPeriod,
            onClick: onPeriodChanged,
          ),
        ],
      ),
    );
  }
}