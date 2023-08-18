import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:equatable/equatable.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/data/local/models/answer.dart';
import 'package:mituna/data/local/models/question.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'db.g.dart';

class QuestionWithAnswers extends Equatable {
  final QuestionData question;
  final List<AnswerData> answers;

  const QuestionWithAnswers(this.question, this.answers);

  @override
  List<Object?> get props => [question.id];
}

@DriftDatabase(tables: [Question, Answer])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<List<QuestionWithAnswers>> getQuestionsWithAnswers(List<String> questionsIdList) async {
    final questionsQuery =
        (select(question)..where((question) => question.id.isIn(questionsIdList))).join([innerJoin(answer, answer.question.equalsExp(question.id))]);

    final rows = await questionsQuery.get();

    final groupedData = <QuestionData, List<AnswerData>>{};

    for (final row in rows) {
      final q = row.readTable(question);
      final a = row.readTable(answer);

      final list = groupedData.putIfAbsent(q, () => []);
      list.add(a);
    }

    return [for (final entry in groupedData.entries) QuestionWithAnswers(entry.key, entry.value)];
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
