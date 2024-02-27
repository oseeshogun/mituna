import 'package:drift/drift.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/data/local/models/question.dart';

class Answers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get value => text()();

  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();

  TextColumn get type => textEnum<AnswerType>()();

  TextColumn get question => text().references(Questions, #id, onDelete: KeyAction.cascade)();
}
