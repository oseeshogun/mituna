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

  Future<List<String>> randomQuestionIdList({int limit = 10, List<String>? categories}) async {
    final result = ((selectOnly(question)
      ..addColumns([question.id])
      ..orderBy([OrderingTerm.random()])
      ..where(categories != null ? question.category.isIn(categories) : question.category.isNotNull())
      ..limit(limit)));
    return (await result.map((row) => row.read(question.id)).get()).map((e) => e.toString()).toList();
  }

  Future<int?> count() {
    final count = countAll(filter: question.id.isNotNull());
    return (selectOnly(question)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
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
