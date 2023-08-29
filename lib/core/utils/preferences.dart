import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesKeys on SharedPreferences {
  bool get offlineQuestionsLoaded => getBool('offline_questions_loaded') ?? false;
  set offlineQuestionsLoaded(bool value) => setBool('offline_questions_loaded', value);

  bool get isShowLostHeartScreenAllowed => getBool('is_show_lost_heart_screen_allowed') ?? true;
  set isShowLostHeartScreenAllowed(bool value) => setBool('is_show_lost_heart_screen_allowed', value);

  double get volume => getDouble('volume') ?? 1.0;
  set volume(double value) => setDouble('volume', value > 1.0 ? min(1.0, value) : max(0.0, value));
}
