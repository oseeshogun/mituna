import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/question.dart';

part 'questions_dao.g.dart';

@DriftAccessor(tables: [Questions])
class QuestionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionsDaoMixin {
  QuestionsDao(AppDatabase db) : super(db);

  Expression<int> get questionsCount => questions.id.count();

  Future<List<Question>> get getAll => select(questions).get();

  Future<Question?> getById(String id) => (select(questions)..where((tbl) => tbl.id.isValue(id))).getSingleOrNull();

  Future<List<String>> randomQuestionIdList({required int limit, required List<String>? categories, required mostPickedLimit}) async {
    final mostPicked = (selectOnly(questions)
      ..addColumns([questions.id, questions.picked])
      ..orderBy([OrderingTerm.desc(questions.picked)])
      ..where(categories != null ? questions.category.isIn(categories) : questions.category.isNotNull())
      ..limit(mostPickedLimit));
    final mostPickedOnlyId = (await mostPicked.map((row) => row.read(questions.id)).get()).map((e) => e.toString()).toList();
    final result = ((selectOnly(questions)
      ..addColumns([questions.id])
      ..orderBy([OrderingTerm.random()])
      ..where((categories != null ? questions.category.isIn(categories) : questions.category.isNotNull()) & (questions.id.isNotIn(mostPickedOnlyId)))
      ..limit(limit)));
    return (await result.map((row) => row.read(questions.id)).get()).map((e) => e.toString()).toList();
  }

  Future<int?> count() {
    final count = countAll(filter: questions.id.isNotNull());
    return (selectOnly(questions)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
  }

  Future<int> incrementPicked(List<String> entries, int value) {
    return (update(questions)..where((tbl) => tbl.id.isIn(entries))).write(QuestionsCompanion(picked: Value(value)));
  }

  Future<Question> create(QuestionsCompanion entry) async {
    return into(questions).insertReturning(entry);
  }

  Future<void> insertMultipleEntries(List<QuestionsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(questions, entries, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<bool> isEmpty() async {
    final questionCount = countAll(filter: questions.id.isNotNull());
    final count = await ((selectOnly(questions)
          ..addColumns([questionCount])
          ..limit(1))
        .asyncMap((result) {
      return result.read(questionCount);
    }).getSingleOrNull());
    return count == null || count < 1;
  }
}
