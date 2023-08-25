import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/data/network/repositories/base_repository.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:mituna/data/network/entities/user_reward.dart';
import 'package:mituna/data/network/services/create_reward.dart';
import 'package:mituna/data/network/services/top_rewards.dart';
import 'package:mituna/data/network/services/user_reward.dart';
import 'package:retrofit/retrofit.dart';

class RewardsRepository extends BaseRepository {
  Future<HttpResponse<dynamic>> create({
    required int topaz,
    required int duration,
    required DateTime date,
  }) async {
    final createRewardService = CreateRewardService(await client());

    return createRewardService.createReward(topaz, duration, date.toIso8601String());
  }

  Future<HttpResponse<List<TopRewardData>>> getTopRewards([RankingPeriod period = RankingPeriod.all]) async {
    final topRewardService = TopRewardService(await client());

    return topRewardService.getTopRewards(period.name);
  }

  Future<HttpResponse<UserRewardData>> getUserReward([RankingPeriod period = RankingPeriod.all]) async {
    final userRewardService = UserRewardService(await client());

    return userRewardService.getUserReward(period.name);
  }
}
