import 'package:mituna/objectbox.g.dart';

import '../entities/answer.dart';

class AnswerRepository {

  late final Box<Answer> _answerBox;

  AnswerRepository._create(Store store) {
    _answerBox = Box<Answer>(store);
  }

  static AnswerRepository create(Store store) {
    return AnswerRepository._create(store);
  }

  Stream<List<Answer>> watchAll() {
    final builder = _answerBox.query();
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  List<Answer> getAll() => _answerBox.getAll();

  int countAll() => _answerBox.count();

  bool answerIsEmpty() => _answerBox.isEmpty();

  List<Answer> getForQuestion(String questionId) {
    return _answerBox.query(Answer_.question.equals(questionId)).build().find();
  }

  void addAll(List<Answer> answers) {
    _answerBox.putMany(answers);
  }

  clear() {
    _answerBox.removeAll();
  }
}