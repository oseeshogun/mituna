import 'package:drift/drift.dart';

import '../../type_converters/list_int.dart';
import 'chapter.dart';

class LawSections extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get number => integer()();

  IntColumn get chapter => integer().references(LawChapters, #id)();

  TextColumn get articles => text().map(const ListIntConverter())();

  @override
  List<Set<Column>> get uniqueKeys => [
        {number, chapter},
        {name, chapter}
      ];
}
