import 'package:mituna/core/constants/env.dart';
import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'question_of_the_day.g.dart';

@RestApi(baseUrl: Env.getQuestionOfTheDayUrl)
abstract class QuestionOfTheDayService {
  factory QuestionOfTheDayService(Dio dio, {String baseUrl}) = _QuestionOfTheDayService;

  @GET('')
  Future<HttpResponse<QuestionOfTheDayData>> getQuestionOfTheDay();
}
