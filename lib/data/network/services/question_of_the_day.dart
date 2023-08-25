import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mituna/data/network/constants.dart';
import 'package:dio/dio.dart';

part 'question_of_the_day.g.dart';

@RestApi(baseUrl: FunctionsHttpUrls.getQuestionOfTheDay)
abstract class QuestionOfTheDayService {
  factory QuestionOfTheDayService(Dio dio, {String baseUrl}) = _QuestionOfTheDayService;

  @GET('')
  Future<HttpResponse<QuestionOfTheDayData>> getQuestionOfTheDay();
}
