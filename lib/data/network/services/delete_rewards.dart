import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'delete_rewards.g.dart';

@RestApi()
abstract class DeleteRewardsService {
  factory DeleteRewardsService(Dio dio, {required String baseUrl}) = _DeleteRewardsService;

  @DELETE('')
  Future<HttpResponse> deleteRewards();
}
