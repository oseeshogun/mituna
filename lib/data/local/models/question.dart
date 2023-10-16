import 'package:drift/drift.dart';
import 'package:mituna/core/constants/enums/all.dart';

class Question extends Table {
  TextColumn get id => text()();

  TextColumn get content => text().unique().withLength(min: 4)();

  TextColumn get type => textEnum<QuestionType>()();

  TextColumn get category => textEnum<QuestionCategory>()();

  IntColumn get picked => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
