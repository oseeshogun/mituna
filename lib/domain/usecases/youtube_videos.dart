import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/local/daos/youtube_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/models/youtube_video.dart';
import 'package:mituna/locator.dart';
import 'package:yaml/yaml.dart';

class YoutubeUsecase extends Usecase {
  Future<List<Map<String, dynamic>>> loadVideosFromAsset() async {
    final yamlString = await rootBundle.loadString('assets/data/youtube.yaml');
    final raw = loadYaml(yamlString);
    return (raw['videos'] as YamlList).map<Map<String, dynamic>>((data) => Map<String, dynamic>.from(data as YamlMap)).toList();
  }

  Future<void> saveVideos(List<Map<String, dynamic>> rawVideos) async {
    final youtubeDao = locator.get<YoutubeDao>();
    final videoCompanions = rawVideos
        .map(
          (rawVideo) => YoutubeVideosCompanion.insert(
            title: rawVideo['title'],
            videoId: rawVideo['video_id'],
            age: rawVideo['age'] is! int ? Value.absent() : Value(rawVideo['age']),
            category: youtubeCategoryFromString(rawVideo['category']),
          ),
        )
        .toList();
    await youtubeDao.insertMultipleEntries(videoCompanions);
  }
}
