import 'package:drift/drift.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/question_dto.dart';
import 'package:mituna/domain/repositories/question_repository.dart';
import 'package:mituna/locator.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  final dao = locator.get<QuestionsDao>();

  @override
  Future<int> incrementPicked(List<String> entries, int value) => dao.incrementPicked(entries, value);

  @override
  Future<void> insertAll(List<QuestionDto> questions) async {
    final entries = questions
        .map((e) => QuestionsCompanion.insert(
              id: e.id,
              content: e.content,
              type: e.type,
              category: e.category,
            ))
        .toList();
    await dao.insertMultipleEntries(entries);
  }

  @override
  Future<List<String>> randomQuestionIdList({int limit = 10, List<String>? categories, mostPickedLimit = 10}) {
    return dao.randomQuestionIdList(limit: limit, categories: categories, mostPickedLimit: mostPickedLimit);
  }

  @override
  Future<List<QuestionWithAnswers>> getQuestionsWithAnswers(List<String> questionsIdList) => dao.db.getQuestionsWithAnswers(questionsIdList);
}
