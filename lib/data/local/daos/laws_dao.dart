import 'package:drift/drift.dart';
import 'package:mituna/core/constants/enums/law_category.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/law/article.dart';
import 'package:mituna/data/local/models/law/chapter.dart';
import 'package:mituna/data/local/models/law/section.dart';
import 'package:mituna/data/local/models/law/title.dart';
import 'package:string_extensions/string_extensions.dart';

part 'laws_dao.g.dart';

@DriftAccessor(tables: [LawArticles, LawTitles, LawChapters, LawSections])
class LawsDao extends DatabaseAccessor<AppDatabase> with _$LawsDaoMixin {
  LawsDao(AppDatabase db) : super(db);

  Future<List<LawArticle>> get getAll => select(lawArticles).get();

  Future<int?> count() {
    final count = countAll(filter: lawArticles.id.isNotNull());
    return (selectOnly(lawArticles)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
  }

  Future<void> insertMultipleEntries({
    required List<LawArticlesCompanion> entries,
    required List<Map<String, dynamic>> titles,
  }) async {
    await transaction(() async {
      await batch((batch) {
        batch.insertAll(lawArticles, entries, mode: InsertMode.insertOrIgnore);
      });

      for (final rawTitle in titles) {
        final titleData = rawTitle[rawTitle.keys.first];
        final titleArticles = List<int>.from(titleData['articles'] ?? []);
        final chapters = (titleData['chapters'] as List?)?.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
        final titleEntry = LawTitlesCompanion.insert(
          name: titleData['name'] as String,
          category: LawCategory.workCode,
          number: rawTitle.keys.first.replaceAll('title_', '').toInt()!,
          articles: titleArticles,
        );
        final titleId = await into(lawTitles).insert(titleEntry);
        for (final chapter in (chapters ?? [])) {
          final chapterData = chapter[chapter.keys.first];
          final chapterArticles = List<int>.from(chapterData['articles'] ?? []);
          final sections = (chapterData['sections'] as List?)?.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
          final chapterEntry = LawChaptersCompanion.insert(
            name: chapterData['name'] as String,
            number: (chapter.keys.first.replaceAll('chapter_', '') as String).toInt()!,
            title: titleId,
            articles: chapterArticles,
          );

          final chapterId = await into(lawChapters).insert(chapterEntry);

          for (final section in (sections ?? [])) {
            final sectionData = section[section.keys.first];
            final sectionArticles = List<int>.from(sectionData['articles'] ?? []);
            final sectionEntry = LawSectionsCompanion.insert(
              name: sectionData['name'] as String,
              number: (section.keys.first.replaceAll('section_', '') as String).toInt()!,
              chapter: chapterId,
              articles: sectionArticles,
            );
            await into(lawSections).insert(sectionEntry);
          }
        }
      }
    });
  }
}
