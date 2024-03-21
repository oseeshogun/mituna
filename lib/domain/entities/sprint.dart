import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/utils/utils.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/question_stat.dart';

class Sprint {
  final int secondsPerQuestion;
  final String id;
  final List<QuestionWithAnswers> questions;
  final QuestionCategory? category;
  final List<String> answered;

  final Map<QuestionWithAnswers, QuestionStat> _questionStats = {};
  late int _hearts;

  Sprint({
    required this.id,
    required this.questions,
    this.secondsPerQuestion = 20,
    int initialHearts = 3,
    this.category,
    this.answered = const [],
  })  : _hearts = initialHearts,
        assert(id.trim().isNotEmpty, "Sprint id can not be empty."),
        assert(questions.isNotEmpty, "Questions can be empty"),
        assert(secondsPerQuestion > 5, "Time per question must be bigger than 5 seconds"),
        assert(initialHearts > 0, "Sprint hearts must be bigger than 0");

  @override
  bool operator ==(Object other) {
    return other is Sprint && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  int get hearts => _hearts;

  bool get finished => _hearts <= 0 || remainingQuestionCount == 0;

  bool get success => (_hearts > 0);

  int get questionCount => questions.length;

  int get remainingQuestionCount => questions.length - _questionStats.keys.length;

  int get questionIndexPlusOne => _questionStats.keys.length + 1;

  int get time => _questionStats.values.fold(0, (previousValue, element) => previousValue + element.elapsed);

  QuestionWithAnswers? get randomQuestion {
    if (finished) return null;
    return randomElement(questions.where((element) => !_questionStats.keys.contains(element)).toList());
  }

  answer(QuestionWithAnswers questionAnswered, Answer? answerGiven, int elapsed) {
    final questionStat = QuestionStat(
      question: questionAnswered,
      elapsed: elapsed,
      foundCorrect: answerGiven?.isCorrect ?? false,
    );
    _questionStats[questionAnswered] = questionStat;
    if (answerGiven == null || !answerGiven.isCorrect) {
      _hearts--;
    }
  }
}
