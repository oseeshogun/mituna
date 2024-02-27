import 'package:drift/drift.dart';

enum YoutubeVideoCategory { histoire, religion, reportage }

YoutubeVideoCategory youtubeCategoryFromString(String value) {
  return YoutubeVideoCategory.values.firstWhere((e) => e.name == value.toLowerCase(), orElse: () => YoutubeVideoCategory.histoire);
}

class YoutubeVideos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().unique()();

  TextColumn get videoId => text().unique()();

  IntColumn get age => integer().withDefault(const Constant(3))();

  TextColumn get category => textEnum<YoutubeVideoCategory>()();

  DateTimeColumn get created => dateTime().clientDefault(() => DateTime.now())();
}
