import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:mituna/data/network/entities/user_reward.dart';
import 'package:mituna/data/network/services/create_reward.dart';
import 'package:mituna/data/network/services/delete_rewards.dart';
import 'package:mituna/data/network/services/top_rewards.dart';
import 'package:mituna/data/network/services/user_reward.dart';
import 'package:retrofit/retrofit.dart';

class RewardsRepository {
  final CreateRewardService _createRewardService;
  final TopRewardService _topRewardService;
  final UserRewardService _userRewardService;
  final DeleteRewardsService _deleteRewardsService;

  RewardsRepository(
    this._createRewardService,
    this._topRewardService,
    this._userRewardService,
    this._deleteRewardsService,
  );

  Future<HttpResponse<dynamic>> create({
    required int topaz,
    required int duration,
    required DateTime date,
  }) =>
      _createRewardService.createReward(topaz, duration, date.toIso8601String());

  Future<HttpResponse<List<TopRewardData>>> getTopRewards([RankingPeriod period = RankingPeriod.all]) => _topRewardService.getTopRewards(period.name);

  Future<HttpResponse<UserRewardData>> getUserReward([RankingPeriod period = RankingPeriod.all]) => _userRewardService.getUserReward(period.name);

  Future<HttpResponse<dynamic>> deleteRewards() => _deleteRewardsService.deleteRewards();
}
