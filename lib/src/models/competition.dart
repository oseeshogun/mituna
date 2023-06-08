import 'package:mituna/src/db/entities/question.dart';

class Competition {
  final bool pending;
  final bool started;
  final String id;
  final bool finished;
  final String? winner;
  List<Question> _questions = [];

  Competition({
    required this.id,
    required this.pending,
    required this.started,
    required this.finished,
    required this.winner,
    required List<Map<String, dynamic>> rawQuestions,
  }) {
    _questions = rawQuestions.map<Question>((raw) {
      return Question.fromJson(raw);
    }).toList();
  }

  List<Question> get questions {
    return _questions;
  }
}
