import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/utils/utils.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/question_stat.dart';

class Sprint {
  final int secondsPerQuestion;
  final int initialHearts;
  final String id;
  final List<QuestionWithAnswers> questions;
  final QuestionCategory? category;

  final Map<QuestionWithAnswers, QuestionStat> _questionStats = {};
  late int _hearts;

  Sprint({
    required this.id,
    required this.questions,
    this.secondsPerQuestion = 20,
    this.initialHearts = 3,
    this.category,
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

  bool get finished => _hearts <= 0 || questionLeft == 0;

  bool get success => _hearts > 0;

  int get questionCount => questions.length;

  int get questionLeft => questions.length - _questionStats.keys.length;

  int get questionOrder => _questionStats.keys.length + 1;

  int get time => _questionStats.values.fold(0, (previousValue, element) => previousValue + element.elapsed);

  QuestionWithAnswers? get randomQuestion {
    if (finished) return null;
    return randomElement(questions.where((element) => !_questionStats.keys.contains(element)).toList());
  }

  answer(QuestionWithAnswers questionAnswered, AnswerData? answerGiven, int elapsed) {
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

  int get topazWon {
    if (!success) return 0;
    int topazs = 0;
    int increment = 1;
    for (int i = 0; i < _questionStats.values.length; i++) {
      final stat = _questionStats.values.toList()[i];
      final QuestionStat? previousQuestionInfo = i - 1 < 0 ? null : _questionStats.values.toList()[i - 1];
      if (previousQuestionInfo == null || !previousQuestionInfo.foundCorrect) {
        increment = 1;
      }
      if (stat.foundCorrect) {
        topazs += increment;
        increment++;
      }
    }
    return topazs;
  }
}
