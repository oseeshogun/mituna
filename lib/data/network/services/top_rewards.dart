import 'package:chopper/chopper.dart';
import 'package:mituna/data/network/entities/top_reward.dart';

part 'top_rewards.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class TopRewardService extends ChopperService {
  static TopRewardService create([ChopperClient? client]) => _$TopRewardService(client);

  @Get()
  Future<Response<List<TopRewardData>>> getTopRewards(@Query('period') String period);
}




