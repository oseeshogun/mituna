import 'package:mituna/src/db/entities/question.dart';

class QuestionSprintInfo {
  final Question question;
  final int elapsed;
  final bool foundCorrect;

  QuestionSprintInfo({
    required this.question,
    required this.elapsed,
    required this.foundCorrect,
  });

  @override
  bool operator ==(Object other) => other is QuestionSprintInfo && other.question == question;

  @override
  int get hashCode => question.hashCode;

  @override
  String toString() {
    return '$question found $foundCorrect in $elapsed seconds\n';
  }
}
