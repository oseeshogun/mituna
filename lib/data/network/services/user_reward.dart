import 'package:mituna/core/constants/env.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mituna/data/network/entities/user_reward.dart';
import 'package:dio/dio.dart';

part 'user_reward.g.dart';

@RestApi(baseUrl: Env.userRewardUrl)
abstract class UserRewardService {
  factory UserRewardService(Dio dio, {String baseUrl}) = _UserRewardService;

  @GET('')
  Future<HttpResponse<UserRewardData>> getUserReward(@Query('period') String period);
}
