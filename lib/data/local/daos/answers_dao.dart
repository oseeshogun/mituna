import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/answer.dart';

part 'answers_dao.g.dart';

@DriftAccessor(tables: [Answers])
class AnswersDao extends DatabaseAccessor<AppDatabase> with _$AnswersDaoMixin {
  AnswersDao(AppDatabase db) : super(db);

  Future<List<Answer>> get getAll => select(answers).get();

  Future<int?> count() {
    final count = countAll(filter: answers.id.isNotNull());
    return (selectOnly(answers)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
  }

  Future<void> insertMultipleEntries(List<AnswersCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(answers, entries, mode: InsertMode.insertOrIgnore);
    });
  }
}
