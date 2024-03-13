import 'package:flutter/services.dart';
import 'package:mituna/core/constants/enums/law_category.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/daos/laws_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/locator.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:yaml/yaml.dart' as yaml;

class LawsUsecase extends Usecase {
  final _lawsDao = locator.get<LawsDao>();

  Future<Map<String, dynamic>> loadWorkCodeFromAsset() async {
    final yamlString = await rootBundle.loadString('assets/data/workcode.yaml');
    final yamlData = Map<String, dynamic>.from(yaml.loadYaml(yamlString));
    return yamlData;
  }

  Future<void> saveWorkcode() async {
    final data = await loadWorkCodeFromAsset();
    final articlesCompanions = (data['articles'] as List)
        .map<Map<String, String>>((e) => Map<String, String>.from(e))
        .map<LawArticlesCompanion>(
          (raw) => LawArticlesCompanion.insert(
            value: raw[raw.keys.first]!,
            number: raw.keys.first.replaceAll('article_', '').toInt()!,
            category: LawCategory.workCode,
          ),
        )
        .toList();

    await _lawsDao.insertMultipleEntries(
      entries: articlesCompanions,
      titles: (data['titles'] as List).map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }
}
