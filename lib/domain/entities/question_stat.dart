

import 'package:mituna/data/local/db.dart';

class QuestionStat {
  final QuestionWithAnswers question;
  final int elapsed;
  final bool foundCorrect;

  QuestionStat({
    required this.question,
    required this.elapsed,
    required this.foundCorrect,
  });

  @override
  bool operator ==(Object other) => other is QuestionStat && other.question == question;

  @override
  int get hashCode => question.hashCode;

  @override
  String toString() {
    return '$question found $foundCorrect in $elapsed seconds\n';
  }
}
