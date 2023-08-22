import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/errors/failures.dart';
import 'package:mituna/core/usecase/usecase.dart';
import 'package:mituna/data/network/repositories/rewards.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/entities/reward_record.dart';
import 'package:mituna/domain/riverpod/providers/ranking.dart';
import 'package:mituna/locator.dart';

class RewardsUsecase extends Usecase {
  final _rewardsRepository = locator.get<RewardsRepository>();

  Future<Either<Failure, List<Ranking>>> getLeaderBoard(RankingPeriod period, bool forceRefresh) async {
    return wrapper(() async {
      final container = locator<ProviderContainer>();

      final stateValue = container.read(rankingsProvider(period.name));

      if (stateValue.isNotEmpty && !forceRefresh) return stateValue;

      final data = <Ranking>[];

      final topRewardsResponse = await _rewardsRepository.getTopRewards(period);
      final userRewardResponse = await _rewardsRepository.getUserReward(period);

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

      data.add(
        Ranking(
          ranking: userRewardResponse.data.ranked,
          uid: FirebaseAuth.instance.currentUser!.uid,
          topaz: userRewardResponse.data.score,
        ),
      );

      return data.toSet().toList();
    });
  }

  Future<Either<Failure, void>> saveRecord(RewardRecord record) {
    return wrapper(() async {
      await _rewardsRepository.create(topaz: record.score, duration: record.duration, date: record.createdAt);
    });
  }
}
