import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/locator.dart';

class OfflineLoadUsecase extends Usecase {
  Future<List<Map<String, dynamic>>> loadQuestionsFromAsset() async {
    final jsonString = await rootBundle.loadString(kReleaseMode ? 'assets/data/questions.json' : 'assets/data/sample.json');
    return (json.decode(jsonString)['questions'] as List).map<Map<String, dynamic>>((data) => Map<String, dynamic>.from(data)).toList();
  }

  Future<void> saveQuestions(List<Map<String, dynamic>> rawQuestions) async {
    final questionsDao = locator.get<QuestionsDao>();
    final answersDao = locator.get<AnswersDao>();
    final questionCompanions = rawQuestions
        .map(
          (rawQuestion) => QuestionCompanion.insert(
            id: rawQuestion['id'],
            content: rawQuestion['text'],
            type: QuestionType.values.firstWhere((type) => type.name == rawQuestion['type'], orElse: () => QuestionType.choice),
            category: QuestionCategory.values.firstWhere((type) => type.name == rawQuestion['category'], orElse: () => QuestionCategory.history),
          ),
        )
        .toList();
    final answerCompanions = rawQuestions.fold<List<AnswerCompanion>>([], (previousValue, rawQuestion) {
      final entries = (rawQuestion['answers'] as List).map((a) => Map<String, dynamic>.from(a)).map((rawAnswer) {
        return AnswerCompanion.insert(
          value: rawAnswer['response'] is bool ? (rawAnswer['response'] == true ? 'Vrai' : 'Faux') : rawAnswer['response'],
          type: AnswerType.values.firstWhere((element) => element.name == rawAnswer['type'], orElse: () => AnswerType.text),
          question: rawQuestion['id'],
          isCorrect: Value(rawAnswer['isCorrect']),
        );
      }).toList();
      return [...previousValue, ...entries];
    });
    await questionsDao.insertMultipleEntries(questionCompanions);
    await answersDao.insertMultipleEntries(answerCompanions);
  }
}
