import 'package:drift/drift.dart';

enum YoutubeVideoCategory { histoire, science }

YoutubeVideoCategory youtubeCategoryFromString(String value) {
  return YoutubeVideoCategory.values.firstWhere((e) => e.name == value.toLowerCase(), orElse: () => YoutubeVideoCategory.histoire);
}

class YoutubeVideos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().unique()();

  TextColumn get videoId => text().unique()();

  IntColumn get clicked => integer().withDefault(const Constant(0))();

  TextColumn get category => textEnum<YoutubeVideoCategory>()();

  DateTimeColumn get created => dateTime().clientDefault(() => DateTime.now())();
}
