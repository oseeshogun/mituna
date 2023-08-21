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

      if (topRewardsResponse.isSuccessful && topRewardsResponse.body != null) {
        final topPlayers = topRewardsResponse.body!;
        topPlayers.sort((a, b) => a.count.compareTo(b.count));
        data.addAll(
          topPlayers.asMap().entries.map(
                (top) => Ranking(
                  ranking: top.key,
                  uid: top.value.id,
                  topaz: top.value.count,
                ),
              ),
        );
      } else {
        throw Exception(topRewardsResponse.error.toString());
      }

      if (userRewardResponse.isSuccessful && userRewardResponse.body != null) {
        data.addAll(userRewardResponse.body!.map((userRanking) => Ranking(
              ranking: userRanking.ranked,
              uid: FirebaseAuth.instance.currentUser!.uid,
              topaz: userRanking.score,
            )));
      }

      return data.toSet().toList();
    });
  }
}
