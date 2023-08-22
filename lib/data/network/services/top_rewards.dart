import 'package:mituna/data/network/constants.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'top_rewards.g.dart';

@RestApi(baseUrl: FunctionsHttpUrls.topReward)
abstract class TopRewardService {
  factory TopRewardService(Dio dio, {String baseUrl}) = _TopRewardService;

  @GET('')
  Future<HttpResponse<List<TopRewardData>>> getTopRewards(@Query('period') String period);
}




