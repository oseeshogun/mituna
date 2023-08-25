import 'package:drift/drift.dart';
import 'package:mituna/core/constants/enums/all.dart';

class Question extends Table {
  TextColumn get id => text()();

  TextColumn get content => text().unique().withLength(min: 4)();

  TextColumn get type => textEnum<QuestionType>()();

  TextColumn get category => textEnum<QuestionCategory>()();

  @override
  Set<Column> get primaryKey => {id};
}
