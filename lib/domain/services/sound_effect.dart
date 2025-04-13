import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_library/sound_library.dart';

class SoundEffects {
  final String badAnswerId = 'sounds/bad_answer.mp3';
  final String goodAnswerId = 'sounds/good_answer.mp3';
  final String sprintFailedId = 'sounds/sprint_failed.mp3';
  final String sprintWonId = 'sounds/sprint_won.mp3';
  final String timeTickingId = 'sounds/time_ticking.mp3';

  Future<void> play(String sound, [int repeat = 0]) async {
    final prefs = locator.get<SharedPreferences>();
    final volume = prefs.volume;
    if (volume == 0) return;
    SoundPlayer.playFromAssetPath(sound);
  }
}
