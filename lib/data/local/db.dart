import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:equatable/equatable.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/data/local/models/answer.dart';
import 'package:mituna/data/local/models/question.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'log_interceptor.dart';

part 'db.g.dart';

class QuestionWithAnswers extends Equatable {
  final Question question;
  final List<Answer> answers;

  const QuestionWithAnswers(this.question, this.answers);

  @override
  List<Object?> get props => [question.id];
}

@DriftDatabase(tables: [
  Questions,
  Answers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (m, from, to) async {
        if (from == 1) {
          await m.createTable(questions);
          await m.createTable(answers);
          await m.deleteTable('question');
          await m.deleteTable('answer');
        }
      },
    );
  }

  Future<List<QuestionWithAnswers>> getQuestionsWithAnswers(List<String> questionsIdList) async {
    final questionsQuery =
        (select(questions)..where((question) => question.id.isIn(questionsIdList))).join([innerJoin(answers, answers.question.equalsExp(questions.id))]);

    final rows = await questionsQuery.get();

    final groupedData = <Question, List<Answer>>{};

    for (final row in rows) {
      final q = row.readTable(questions);
      final a = row.readTable(answers);

      final list = groupedData.putIfAbsent(q, () => []);

      if (list.length <= 4) list.add(a);
    }

    return [for (final entry in groupedData.entries) QuestionWithAnswers(entry.key, entry.value)];
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file).interceptWith(LogInterceptor());
  });
}
