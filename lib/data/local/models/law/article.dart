import 'package:drift/drift.dart';
import 'package:mituna/core/constants/enums/law_category.dart';

class LawArticles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get value => text()();

  IntColumn get number => integer()();

  TextColumn get category => textEnum<LawCategory>()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {number, category},
        {value, category}
      ];
}
