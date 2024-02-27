import 'package:drift/drift.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/youtube_video.dart';

part 'youtube_dao.g.dart';

@DriftAccessor(tables: [YoutubeVideos])
class YoutubeDao extends DatabaseAccessor<AppDatabase> with _$YoutubeDaoMixin {
  YoutubeDao(AppDatabase db) : super(db);

  Future<List<YoutubeVideo>> get getAll => select(youtubeVideos).get();

  Stream<List<YoutubeVideo>> watchAll() => select(youtubeVideos).watch();

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
