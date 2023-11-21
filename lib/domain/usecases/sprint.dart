import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/network/repositories/question_of_the_day.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SprintUsecase extends Usecase {
  final _db = locator.get<AppDatabase>();
  final _questionsDao = locator.get<QuestionsDao>();
  final _answersDao = locator.get<AnswersDao>();
  final _questionOfTheDayRepository = locator.get<QuestionOfTheDayRepository>();
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
      mostPickedLimit: kDebugMode ? (categories.length < 2 ? 5 : 10) : (categories.length < 2 ? 20 : 40),
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

  Future<void> saveTopazForAuthenticatedUser(int topaz, int duration) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null && topaz <= 0) return;
    final container = locator.get<ProviderContainer>();
    final firestoreUser = await container.read(firestoreAuthenticatedUserStreamProvider.future);
    FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'diamonds': (firestoreUser?.diamonds ?? 0) + topaz,
        'last_time_win': DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );
    await FirebaseFirestore.instance.collection('rewards').doc(uid).collection('records').add({
      'state': RewardRecordState.queue.name,
      'uid': uid,
      'score': topaz,
      'duration': duration,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<Either<Failure, Sprint>> sprintQuestionOfTheDay() async {
    return wrapper(() async {
      final generatedId = const Uuid().v4();
      final format = DateFormat('dd/MM/yyyy');
      final today = format.format(DateTime.now());

      String? todayQuestionId = prefs.getString(today);

      if (todayQuestionId == null) {
        final questionOfTheDayResponse = await _questionOfTheDayRepository.getQuestionOfTheDay();
        final questionOfTheDayData = questionOfTheDayResponse.data;

        final questionOnPhone = await _questionsDao.getById(questionOfTheDayData.id);

        if (questionOnPhone == null) {
          final questionEntry = QuestionCompanion.insert(
            id: questionOfTheDayData.id,
            content: questionOfTheDayData.question,
            type: QuestionType.choice,
            category: QuestionCategory.values.firstWhere((v) => v.name == questionOfTheDayData.category, orElse: () => QuestionCategory.history),
          );
          final answerCompanions = questionOfTheDayData.assertions
              .asMap()
              .entries
              .map(
                (assertionEntry) => AnswerCompanion.insert(
                  value: assertionEntry.value,
                  isCorrect: Value(assertionEntry.value == questionOfTheDayData.reponse),
                  type: AnswerType.text,
                  question: questionOfTheDayData.id,
                ),
              )
              .toList();
          await _questionsDao.create(questionEntry);
          await _answersDao.insertMultipleEntries(answerCompanions);
        }

        prefs.setString(today, questionOfTheDayData.id);

        todayQuestionId = questionOfTheDayData.id;
      }

      final List<QuestionWithAnswers> questions = await _db.getQuestionsWithAnswers([todayQuestionId]);

      return Sprint(id: generatedId, questions: questions, category: null, initialHearts: 1, answered: _getAnsweredQuestions(questions), topazMultiplier: 10);
    });
  }
}
