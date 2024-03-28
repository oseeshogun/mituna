import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/domain/entities/answer_dto.dart';
import 'package:mituna/domain/entities/question_dto.dart';
import 'package:mituna/domain/repositories/answer_repository.dart';
import 'package:mituna/domain/repositories/question_repository.dart';
import 'package:mituna/locator.dart';

class SaveQuestionsInDbUsecase extends Usecase<void> {
  final _answerRepository = locator.get<AnswerRepository>();
  final _questionRepository = locator.get<QuestionRepository>();

  @override
  Future<void> execute() async {
    final rawQuestions = await _loadQuestionsFromAsset();
    final questions = rawQuestions
        .map(
          (rawQuestion) => QuestionDto(
            id: rawQuestion['id'],
            content: rawQuestion['text'],
            type: QuestionType.values.firstWhere((type) => type.name == rawQuestion['type'], orElse: () => QuestionType.choice),
            category: QuestionCategory.values.firstWhere((type) => type.name == rawQuestion['category'], orElse: () => QuestionCategory.history),
          ),
        )
        .toList();
    final answers = rawQuestions.fold<List<AnswerDto>>([], (previousValue, rawQuestion) {
      final entries = (rawQuestion['answers'] as List).map((a) => Map<String, dynamic>.from(a)).map((rawAnswer) {
        return AnswerDto(
          value: rawAnswer['response'] is bool ? (rawAnswer['response'] == true ? 'Vrai' : 'Faux') : rawAnswer['response'],
          type: AnswerType.values.firstWhere((element) => element.name == rawAnswer['type'], orElse: () => AnswerType.text),
          question: rawQuestion['id'],
          isCorrect: rawAnswer['isCorrect'],
        );
      }).toList();
      return [...previousValue, ...entries];
    });

    await _questionRepository.insertAll(questions);
    await _answerRepository.insertAll(answers);
  }

  Future<List<Map<String, dynamic>>> _loadQuestionsFromAsset() async {
    final jsonString = await rootBundle.loadString('assets/data/questions.json');
    return (json.decode(jsonString)['questions'] as List).map<Map<String, dynamic>>((data) => Map<String, dynamic>.from(data)).toList();
  }
}
