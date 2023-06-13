import 'package:mituna/objectbox.g.dart';
import 'package:mituna/src/enums/all.dart';


import '../entities/question.dart';

class QuestionRepository {

  late final Box<Question> _questionBox;

  QuestionRepository._create(Store store) {
    _questionBox = Box<Question>(store);
  }

  static QuestionRepository create(Store store)  {
    return QuestionRepository._create(store);
  }

  Stream<List<Question>> watchAll() {
    final builder = _questionBox.query();
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  List<Question> getAll() => _questionBox.getAll();

  int countAll() => _questionBox.count();

  bool questionIsEmpty() => _questionBox.isEmpty();

  void addAll(List<Question> questions) {
    _questionBox.putMany(questions);
  }

  List<Question> getAllForCategory(QuestionCategory category) {
    return _questionBox.query(Question_.dbCategory.equals(category.name)).build().find();
  }

  int countAllForCategory(QuestionCategory category) {
    return _questionBox.query(Question_.dbCategory.equals(category.name)).build().count();
  }

  void clear() {
    _questionBox.removeAll();
  }
}
