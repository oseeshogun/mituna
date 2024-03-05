import 'package:mituna/core/constants/env.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'create_reward.g.dart';

@RestApi(baseUrl: Env.createRewardUrl)
abstract class CreateRewardService {
  factory CreateRewardService(Dio dio, {String baseUrl}) = _CreateRewardService;

  @POST('')
  Future<HttpResponse> createReward(@Field('topaz') int topaz, @Field('duration') int duration, @Field('date') String date);
}