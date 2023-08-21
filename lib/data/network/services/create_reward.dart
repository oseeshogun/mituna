import 'package:chopper/chopper.dart';

part 'create_reward.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class CreateRewardService extends ChopperService {
  static CreateRewardService create([ChopperClient? client]) => _$CreateRewardService(client);

  @Post()
  Future<Response> createReward(@Field('topaz') int topaz, @Field('duration') int duration, @Field('date') String date);
}