import 'dart:convert';

import 'package:drift/drift.dart';

class ListIntConverter extends TypeConverter<List<int>, String> {
  const ListIntConverter();

  @override
  List<int> fromSql(String fromDb) {
    return List<int>.from(jsonDecode(fromDb) as List<dynamic>);
  }

  @override
  String toSql(List<int> value) {
    return jsonEncode(value);
  }
}
