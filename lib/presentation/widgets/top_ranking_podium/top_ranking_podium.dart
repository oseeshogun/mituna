part of '../all.dart';

class TopRankingPodium extends StatelessWidget {
  const TopRankingPodium({
    super.key,
    required this.podium,
  });

  /// First, second and third place. Any slot may be null when there are
  /// fewer than three ranked players.
  final Tuple3<Ranking?, Ranking?, Ranking?> podium;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * .13,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .51,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopRankedInPodium(
              ranking: podium.item2,
              height: MediaQuery.of(context).size.height * .22,
              width: MediaQuery.of(context).size.width * .2,
              color: AppColors.kColorMarigoldYellow,
              painter: RankSecondPainter(),
              position: '2',
              profilOffsetY: -100,
            ),
            TopRankedInPodium(
              ranking: podium.item1,
              height: MediaQuery.of(context).size.height * .24,
              width: MediaQuery.of(context).size.width * .2,
              color: AppColors.kColorYellow,
              painter: RankFirstPainter(),
              position: '1',
              profilOffsetY: -120,
            ),
            TopRankedInPodium(
              ranking: podium.item3,
              height: MediaQuery.of(context).size.height * .20,
              width: MediaQuery.of(context).size.width * .2,
              color: AppColors.kColorEarlsGreen,
              painter: RankThirdPainter(),
              position: '3',
              profilOffsetY: -100,
            ),
          ],
        ),
      ),
    );
  }
}
