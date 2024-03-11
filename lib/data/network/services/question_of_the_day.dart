import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'question_of_the_day.g.dart';

@RestApi()
abstract class QuestionOfTheDayService {
  factory QuestionOfTheDayService(Dio dio, {required String baseUrl}) = _QuestionOfTheDayService;

  @GET('/')
  Future<HttpResponse<QuestionOfTheDayData>> getQuestionOfTheDay();
}
