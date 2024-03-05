import 'package:mituna/core/constants/env.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'delete_rewards.g.dart';

@RestApi(baseUrl: Env.deleteRewardUrl)
abstract class DeleteRewardsService {
  factory DeleteRewardsService(Dio dio, {String baseUrl}) = _DeleteRewardsService;

  @DELETE('')
  Future<HttpResponse> deleteRewards();
}
