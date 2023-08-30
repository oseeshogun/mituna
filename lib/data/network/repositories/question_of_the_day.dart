import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:mituna/data/network/services/question_of_the_day.dart';
import 'package:retrofit/retrofit.dart';

class QuestionOfTheDayRepository {
  final QuestionOfTheDayService _questionOfTheDayService;

  QuestionOfTheDayRepository(this._questionOfTheDayService);

  Future<HttpResponse<QuestionOfTheDayData>> getQuestionOfTheDay() => _questionOfTheDayService.getQuestionOfTheDay();
}
