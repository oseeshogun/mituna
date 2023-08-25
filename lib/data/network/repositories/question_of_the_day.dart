import 'package:mituna/core/data/network/repositories/base_repository.dart';
import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:mituna/data/network/services/question_of_the_day.dart';
import 'package:retrofit/retrofit.dart';

class QuestionOfTheDayRepository extends BaseRepository {

  Future<HttpResponse<QuestionOfTheDayData>> getQuestionOfTheDay() async {
    final questionOfTheDayService = QuestionOfTheDayService(await client());

    return questionOfTheDayService.getQuestionOfTheDay();
  }
}