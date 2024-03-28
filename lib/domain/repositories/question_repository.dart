import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/question_dto.dart';

abstract class QuestionRepository {
  Future<List<String>> randomQuestionIdList({int limit = 10, List<String>? categories, mostPickedLimit = 10});

  Future<int> incrementPicked(List<String> entries, int value);

  Future<void> insertAll(List<QuestionDto> entries);

  Future<List<QuestionWithAnswers>> getQuestionsWithAnswers(List<String> questionsIdList);
}
