import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/question.dart';

part 'questions_dao.g.dart';

@DriftAccessor(tables: [Question])
class QuestionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionsDaoMixin {
  QuestionsDao(AppDatabase db) : super(db);

  Expression<int> get questionsCount => question.id.count();

  Future<List<QuestionData>> get getAll => select(question).get();

  Stream<int?> countAllQuestion() {
    final count = countAll(filter: question.id.isNotNull());
    return (selectOnly(question)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).watchSingle();
  }
}
