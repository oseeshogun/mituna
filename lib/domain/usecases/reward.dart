import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/network/repositories/rewards.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/entities/reward_record.dart';
import 'package:mituna/locator.dart';

class RewardsUsecase extends Usecase {
  final _rewardsRepository = locator.get<RewardsRepository>();

  Future<Either<Failure, List<Ranking>>> topRankings(RankingPeriod period) async {
    return wrapper(() async {
      final topRewardsResponse = await _rewardsRepository.getTopRewards(period);

      final topPlayers = topRewardsResponse.data;
      topPlayers.sort((a, b) => b.count.compareTo(a.count));

      return topPlayers
          .asMap()
          .entries
          .map(
            (top) => Ranking(
              ranking: top.key,
              uid: top.value.id,
              topaz: top.value.count,
            ),
          )
          .toList();
    });
  }

  Future<Either<Failure, List<Ranking>>> userRanking(RankingPeriod period) async {
    return wrapper(() async {
      final userRewardResponse = await _rewardsRepository.getUserReward(period);

      return [
        Ranking(
          ranking: userRewardResponse.data.ranked,
          uid: FirebaseAuth.instance.currentUser!.uid,
          topaz: userRewardResponse.data.score,
        ),
      ];
    });
  }

  Future<Either<Failure, void>> saveRecord(RewardRecord record) {
    return wrapper(() async {
      await _rewardsRepository.create(topaz: record.score, duration: record.duration, date: record.createdAt);
    });
  }
}
