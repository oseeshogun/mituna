import 'package:mituna/data/network/client.dart';
import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:mituna/data/network/services/question_of_the_day.dart';
import 'package:retrofit/retrofit.dart';

class QuestionOfTheDayRepository {
  Future<HttpResponse<QuestionOfTheDayData>> getQuestionOfTheDay() async {
    final questionOfTheDayService = QuestionOfTheDayService(client());

    return questionOfTheDayService.getQuestionOfTheDay();
  }
}
