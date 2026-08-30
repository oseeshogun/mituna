import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/repositories/question_repository.dart';
import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StartSprintUsecase extends UsecaseFamily<Sprint, QuestionCategory?> {
  final _questionRepository = locator.get<QuestionRepository>();
  final _prefs = locator.get<SharedPreferences>();

  @override
  Future<Sprint> execute(QuestionCategory? category) async {
    final generatedId = const Uuid().v4();
    final categories = category != null
        ? <String>[category.name]
        : <String>[
            ...QuestionCategory.values
                .where((element) => element.isFavorite)
                .map((e) => e.name),
          ];
    final questionsIdList = await _questionRepository.randomQuestionIdList(
      categories: categories,
      limit: 10,
      mostPickedLimit: (categories.length < 2 ? 20 : 40),
    );
    final questions =
        await _questionRepository.getQuestionsWithAnswers(questionsIdList);

    // increment picked
    _questionRepository.incrementPicked(
        questionsIdList,
        questions.fold(
                0,
                (previousValue, element) =>
                    max(previousValue, element.question.picked)) +
            1);

    return Sprint(
      id: generatedId,
      questions: questions,
      category: category,
      answered: _getAnsweredQuestions(questions),
    );
  }

  List<String> _getAnsweredQuestions(List<QuestionWithAnswers> questions) {
    return questions
        .where((q) => _prefs.getBool('answered_${q.question.id}') == true)
        .map((q) => q.question.id)
        .toList();
  }
}

/// Credits the topaz won in a sprint to the authenticated user's Firestore
/// document. No-op when the user is anonymous or nothing was won.
class SaveTopazRewardUsecase extends UsecaseFamily<void, int> {
  @override
  Future<void> execute(int topaz) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || topaz <= 0) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'diamonds': FieldValue.increment(topaz),
        'last_time_win': DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );
  }
}
