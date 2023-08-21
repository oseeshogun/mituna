import 'package:chopper/chopper.dart';
import 'package:mituna/data/network/entities/user_reward.dart';

part 'user_reward.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class UserRewardService extends ChopperService {
  static UserRewardService create([ChopperClient? client]) => _$UserRewardService(client);

  @Get()
  Future<Response<List<UserRewardData>>> getUserReward(@Query('period') String period);
}
