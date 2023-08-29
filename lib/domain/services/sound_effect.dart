import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';


class SoundEffects {
  Soundpool pool = Soundpool.fromOptions(
    options: const SoundpoolOptions(streamType: StreamType.notification),
  );

  late final int badAnswerId;
  late final int goodAnswerId;
  late final int sprintFailedId;
  late final int sprintWonId;
  late final int timeTickingId;

  List<int?> streams = [];

  SoundEffects() {
    initSounds();
  }

  initSounds() async {
    badAnswerId = await rootBundle.load('assets/sounds/bad_answer.mp3').then((ByteData soundData) {
      return pool.load(soundData);
    });
    goodAnswerId = await rootBundle.load('assets/sounds/good_answer.mp3').then((ByteData soundData) {
      return pool.load(soundData);
    });
    sprintFailedId = await rootBundle.load('assets/sounds/sprint_failed.mp3').then((ByteData soundData) {
      return pool.load(soundData);
    });
    sprintWonId = await rootBundle.load('assets/sounds/sprint_won.mp3').then((ByteData soundData) {
      return pool.load(soundData);
    });
    timeTickingId = await rootBundle.load('assets/sounds/time_ticking.mp3').then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  Future<void> play(int soundId, [int repeat = 0]) async {
    final prefs = locator.get<SharedPreferences>();
    final volume = prefs.volume;
    if (volume == 0) return;
    try {
      pool.setVolume(
        soundId: soundId,
        volume: volume,
      );
    } catch (e) {
      debugPrint("play: $e");
    }
    int? streamId = await pool.play(soundId, repeat: repeat);
    if (soundId == timeTickingId) {
      streams.add(streamId);
    }
  }

  Future<void> stop() async {
    try {
      for (final streamId in streams) {
        if (streamId != null) pool.stop(streamId);
      }
      streams.clear();
    } catch (e) {
      debugPrint("stop: $e");
    }
  }
}
