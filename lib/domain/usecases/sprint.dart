import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/repositories/question_repository.dart';
import 'package:mituna/domain/usecases/leaderboard.dart';
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
    return _answeredQuestionIds(_prefs, questions);
  }
}

List<String> _answeredQuestionIds(
    SharedPreferences prefs, List<QuestionWithAnswers> questions) {
  return questions
      .where((q) => prefs.getBool('answered_${q.question.id}') == true)
      .map((q) => q.question.id)
      .toList();
}

/// Builds a single-question "question du jour" sprint from the local database.
///
/// One question is pinned per calendar day in [SharedPreferences] so every
/// launch that day replays the same one. The pinned question is re-picked if it
/// no longer exists locally. Config mirrors the historic QOTD: a single
/// question, one life, and a 10× topaz multiplier (already-answered questions
/// still award nothing).
class StartQuestionOfTheDayUsecase extends Usecase<Sprint> {
  final _questionRepository = locator.get<QuestionRepository>();
  final _prefs = locator.get<SharedPreferences>();

  String get _todayStamp {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  String get _todayKey => 'qotd_$_todayStamp';
  String get _todayWonKey => 'qotd_won_$_todayStamp';

  /// Whether the user has already succeeded at today's question. The home
  /// screen hides the button once this is true.
  bool get isTodayQuestionWon => _prefs.getBool(_todayWonKey) ?? false;

  /// Records that today's question has been beaten. Called from the sprint
  /// screen when a QOTD sprint finishes successfully.
  Future<void> markTodayQuestionWon() => _prefs.setBool(_todayWonKey, true);

  Future<String?> _pickRandomQuestionId() async {
    final ids = await _questionRepository.randomQuestionIdList(
      categories: null,
      limit: 1,
      mostPickedLimit: 0,
    );
    return ids.isEmpty ? null : ids.first;
  }

  @override
  Future<Sprint> execute() async {
    var questionId = _prefs.getString(_todayKey);

    var questions = questionId == null
        ? const <QuestionWithAnswers>[]
        : await _questionRepository.getQuestionsWithAnswers([questionId]);

    if (questions.isEmpty) {
      questionId = await _pickRandomQuestionId();
      if (questionId == null) {
        throw Exception('Aucune question disponible.');
      }
      await _prefs.setString(_todayKey, questionId);
      questions = await _questionRepository.getQuestionsWithAnswers([questionId]);
    }

    return Sprint(
      id: const Uuid().v4(),
      questions: questions,
      category: null,
      initialHearts: 1,
      topazMultiplier: 10,
      isQuestionOfTheDay: true,
      answered: _answeredQuestionIds(_prefs, questions),
    );
  }
}

/// Credits the topaz won in a sprint to the signed-in user's Firestore
/// document and, for non-anonymous accounts, mirrors it to the public
/// `leaderboard` collection. No-op when signed out or nothing was won.
class SaveTopazRewardUsecase extends UsecaseFamily<void, int> {
  @override
  Future<void> execute(int topaz) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null || topaz <= 0) return;
    final uid = firebaseUser.uid;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    await userDoc.set(
      {
        'diamonds': FieldValue.increment(topaz),
        'last_time_win': DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );

    // Anonymous accounts keep their topaz privately but never appear on the
    // public leaderboard.
    if (firebaseUser.isAnonymous) return;

    // Mirror the updated totals into the public leaderboard entry so the
    // ranking screen never has to fan out to per-user profile documents.
    await publishLeaderboardEntry(uid);
  }
}
