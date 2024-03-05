import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/youtube_video.dart';

part 'youtube_dao.g.dart';

@DriftAccessor(tables: [YoutubeVideos])
class YoutubeDao extends DatabaseAccessor<AppDatabase> with _$YoutubeDaoMixin {
  YoutubeDao(AppDatabase db) : super(db);

  Future<List<YoutubeVideo>> get getAll => select(youtubeVideos).get();

  Stream<List<YoutubeVideo>> watchAll() => select(youtubeVideos).watch();

  Stream<List<YoutubeVideo>> watchAllByCategory(String category) {
    return (select(youtubeVideos)
          ..where((tbl) => tbl.category.lower().equals(category.toLowerCase()))
          ..orderBy([(u) => OrderingTerm.asc(u.clicked)]))
        .watch();
  }

  Stream<List<String>> watchCategories() {
    final query = selectOnly(youtubeVideos)..addColumns([youtubeVideos.category]);
    return query.watch().asyncMap((event) => event.map((e) => e.read(youtubeVideos.category)).whereType<String>().toSet().toList());
  }

  Future<int?> count() {
    final count = countAll(filter: youtubeVideos.id.isNotNull());
    return (selectOnly(youtubeVideos)..addColumns([count])).asyncMap((result) {
      return result.read(count);
    }).getSingleOrNull();
  }

  Future<void> insertMultipleEntries(List<YoutubeVideosCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(youtubeVideos, entries, mode: InsertMode.insertOrIgnore);
    });
  }
}
