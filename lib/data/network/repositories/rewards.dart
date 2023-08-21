import 'package:chopper/chopper.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/data/network/constants.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:mituna/data/network/entities/user_reward.dart';
import 'package:mituna/data/network/interceptors/authenticator.dart';
import 'package:mituna/data/network/services/create_reward.dart';
import 'package:mituna/data/network/services/top_rewards.dart';
import 'package:mituna/data/network/services/user_reward.dart';

class RewardsRepository {
  ChopperClient _client(String baseUrl) {
    return ChopperClient(
      baseUrl: Uri.https(baseUrl),
      authenticator: FirebaseAuthenticator(),
    );
  }

  Future<Response<dynamic>> create({
    required int topaz,
    required int duration,
    required DateTime date,
  }) async {
    final createRewardService = CreateRewardService.create(_client(FunctionsHttpUrls.createReward));

    return createRewardService.createReward(topaz, duration, date.toIso8601String());
  }

  Future<Response<List<TopRewardData>>> getTopRewards([RankingPeriod period = RankingPeriod.all]) async {
    final topRewardService = TopRewardService.create(_client(FunctionsHttpUrls.topReward));

    return topRewardService.getTopRewards(period.name);
  }

  Future<Response<List<UserRewardData>>> getUserReward([RankingPeriod period = RankingPeriod.all]) async {
    final userRewardService = UserRewardService.create(_client(FunctionsHttpUrls.userReawrd));

    return userRewardService.getUserReward(period.name);
  }
}
