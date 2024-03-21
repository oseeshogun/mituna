import 'dart:math';

import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SprintUsecase extends Usecase {
  final _db = locator.get<AppDatabase>();
  final _questionsDao = locator.get<QuestionsDao>();
  final prefs = locator.get<SharedPreferences>();

  List<String> _getAnsweredQuestions(List<QuestionWithAnswers> questions) {
    return questions.where((q) => prefs.getBool('answered_${q.question.id}') == true).map((q) => q.question.id).toList();
  }

  Future<Sprint> start([QuestionCategory? category]) async {
    final generatedId = const Uuid().v4();
    final categories = category != null
        ? <String>[category.name]
        : <String>[
            ...QuestionCategory.values.where((element) => element.isFavorite).map((e) => e.name).toList(),
          ];
    final questionsIdList = await _questionsDao.randomQuestionIdList(
      categories: categories,
      limit: 10,
      mostPickedLimit: (categories.length < 2 ? 20 : 40),
    );
    final questions = await _db.getQuestionsWithAnswers(questionsIdList);

    // increment picked
    _questionsDao.incrementPicked(questionsIdList, questions.fold(0, (previousValue, element) => max(previousValue, element.question.picked)) + 1);

    return Sprint(
      id: generatedId,
      questions: questions,
      category: category,
      answered: _getAnsweredQuestions(questions),
    );
  }

}
