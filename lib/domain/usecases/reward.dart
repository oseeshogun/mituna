import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/errors/failures.dart';
import 'package:mituna/core/usecase/usecase.dart';
import 'package:mituna/data/network/repositories/rewards.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/locator.dart';

class RewardsUsecase extends Usecase {
  final rewardsRepository = locator.get<RewardsRepository>();

  Future<Either<Failure, List<Ranking>>> getLeaderBoard(RankingPeriod period) async {
    return wrapper(() async {
      final data = <Ranking>[];

      final topRewardsResponse = await rewardsRepository.getTopRewards(period);
      final userRewardResponse = await rewardsRepository.getUserReward(period);

      final topPlayers = topRewardsResponse.data;
      topPlayers.sort((a, b) => b.count.compareTo(a.count));
      data.addAll(
        topPlayers.asMap().entries.map(
              (top) => Ranking(
                ranking: top.key,
                uid: top.value.id,
                topaz: top.value.count,
              ),
            ),
      );

      data.addAll(
        userRewardResponse.data.map(
          (userRanking) => Ranking(
            ranking: userRanking.ranked,
            uid: FirebaseAuth.instance.currentUser!.uid,
            topaz: userRanking.score,
          ),
        ),
      );

      return data.toSet().toList();
    });
  }
}
