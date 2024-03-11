import 'package:drift/drift.dart';

import '../../type_converters/list_int.dart';
import 'title.dart';

class LawChapters extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get number => integer()();

  IntColumn get title => integer().references(LawTitles, #id)();

  TextColumn get articles => text().map(const ListIntConverter())();

  @override
  List<Set<Column>> get uniqueKeys => [
        {number, title},
        {name, title}
      ];
}
