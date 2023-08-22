part of 'all.dart';

class PeriodText extends StatelessWidget {
  const PeriodText({
    super.key,
    required this.text,
    required this.period,
    required this.currentPeriod,
    required this.onClick,
  });

  final RankingPeriod period;
  final RankingPeriod currentPeriod;
  final String text;
  final void Function(RankingPeriod value) onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(period),
      child: Text(
        text,
        style: TextStyle(
          color: currentPeriod == period ? AppColors.kColorBlueRibbon : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
