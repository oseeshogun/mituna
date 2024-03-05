import 'package:mituna/core/constants/env.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'top_rewards.g.dart';

@RestApi(baseUrl: Env.topRewardUrl)
abstract class TopRewardService {
  factory TopRewardService(Dio dio, {String baseUrl}) = _TopRewardService;

  @GET('')
  Future<HttpResponse<List<TopRewardData>>> getTopRewards(@Query('period') String period);
}




