import 'package:drift/drift.dart';
import 'package:mituna/core/constants/enums/law_category.dart';

import '../../type_converters/list_int.dart';


class LawTitles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get number => integer()();

  TextColumn get category => textEnum<LawCategory>()();

  TextColumn get articles => text().map(const ListIntConverter())();

  @override
  List<Set<Column>> get uniqueKeys => [
        {number, category},
        {name, category}
      ];
}
