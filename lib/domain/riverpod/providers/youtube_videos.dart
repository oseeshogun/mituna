import 'package:mituna/data/local/daos/youtube_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'youtube_videos.g.dart';

@riverpod
Stream<List<YoutubeVideo>> watchYoutubeVideos(WatchYoutubeVideosRef ref, String category) {
  final dao = locator.get<YoutubeDao>();
  return dao.watchAllByCategory(category);
}

@riverpod
Stream<List<String>> watchCategories(WatchCategoriesRef ref) {
  final dao = locator.get<YoutubeDao>();
  return dao.watchCategories();
}