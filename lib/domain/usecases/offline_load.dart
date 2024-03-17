import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/usecases/law.dart';
import 'package:mituna/locator.dart';

class OfflineLoadUsecase extends Usecase {
  Future<List<Map<String, dynamic>>> _loadQuestionsFromAsset() async {
    final jsonString = await rootBundle.loadString('assets/data/questions.json');
    return (json.decode(jsonString)['questions'] as List).map<Map<String, dynamic>>((data) => Map<String, dynamic>.from(data)).toList();
  }

  Future<void> saveQuestions() async {
    final rawQuestions = await _loadQuestionsFromAsset();
    final questionsDao = locator.get<QuestionsDao>();
    final answersDao = locator.get<AnswersDao>();
    final questionCompanions = rawQuestions
        .map(
          (rawQuestion) => QuestionsCompanion.insert(
            id: rawQuestion['id'],
            content: rawQuestion['text'],
            type: QuestionType.values.firstWhere((type) => type.name == rawQuestion['type'], orElse: () => QuestionType.choice),
            category: QuestionCategory.values.firstWhere((type) => type.name == rawQuestion['category'], orElse: () => QuestionCategory.history),
          ),
        )
        .toList();
    final answerCompanions = rawQuestions.fold<List<AnswersCompanion>>([], (previousValue, rawQuestion) {
      final entries = (rawQuestion['answers'] as List).map((a) => Map<String, dynamic>.from(a)).map((rawAnswer) {
        return AnswersCompanion.insert(
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

  Future<void> saveWorkcode() async {
    final lawsUsecase = LawsUsecase();
    await lawsUsecase.saveWorkcode();
  }
}
