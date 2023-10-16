import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/question.dart';

part 'questions_dao.g.dart';

@DriftAccessor(tables: [Question])
class QuestionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionsDaoMixin {
  QuestionsDao(AppDatabase db) : super(db);

  Expression<int> get questionsCount => question.id.count();

  Future<List<QuestionData>> get getAll => select(question).get();

  Future<QuestionData?> getById(String id) => (select(question)..where((tbl) => tbl.id.isValue(id))).getSingleOrNull();

  Future<List<String>> randomQuestionIdList({int limit = 10, List<String>? categories, mostPickedLimit = 10}) async {
    final mostPicked = (selectOnly(question)
      ..addColumns([question.id, question.picked])
      ..orderBy([OrderingTerm.desc(question.picked)])
      ..where(categories != null ? question.category.isIn(categories) : question.category.isNotNull())
      ..limit(mostPickedLimit));
    final mostPickedOnlyId = (await mostPicked.map((row) => row.read(question.id)).get()).map((e) => e.toString()).toList();
    final result = ((selectOnly(question)
      ..addColumns([question.id])
      ..orderBy([OrderingTerm.random()])
      ..where((categories != null ? question.category.isIn(categories) : question.category.isNotNull()) & (question.id.isNotIn(mostPickedOnlyId)))
      ..limit(limit)));
    return (await result.map((row) => row.read(question.id)).get()).map((e) => e.toString()).toList();
  }

  Future<int?> count() {
    final count = countAll(filter: question.id.isNotNull());
    return (selectOnly(question)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
  }

  Future<int> incrementPicked(List<String> questions, int value) {
    return (update(question)..where((tbl) => tbl.id.isIn(questions))).write(QuestionCompanion(picked: Value(value)));
  }

  Future<QuestionData> create(QuestionCompanion entry) async {
    return into(question).insertReturning(entry);
  }

  Future<void> insertMultipleEntries(List<QuestionCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(question, entries, mode: InsertMode.insertOrReplace);
    });
  }
}
