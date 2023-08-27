import 'package:mituna/data/network/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'delete_rewards.g.dart';

@RestApi(baseUrl: FunctionsHttpUrls.deleteRewards)
abstract class DeleteRewardsService {
  factory DeleteRewardsService(Dio dio, {String baseUrl}) = _DeleteRewardsService;

  @DELETE('')
  Future<HttpResponse> deleteRewards();
}
