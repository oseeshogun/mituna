import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/answer.dart';

part 'answers_dao.g.dart';

@DriftAccessor(tables: [Answer])
class AnswersDao extends DatabaseAccessor<AppDatabase> with _$AnswersDaoMixin {
  AnswersDao(AppDatabase db) : super(db);

  Expression<int> get answerCount => answer.id.count();

  Future<List<AnswerData>> get getAll => select(answer).get();

  Future<int?> countAllAnswer() {
    final count = countAll(filter: answer.id.isNotNull());
    return (selectOnly(answer)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
  }

  Future<void> insertMultipleEntries(List<AnswerCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(answer, entries, mode: InsertMode.insertOrReplace);
    });
  }
}
