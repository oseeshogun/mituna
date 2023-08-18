import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesKeys on SharedPreferences {
  bool get offlineQuestionsLoaded => getBool('offline_questions_loaded') ?? false;
  set offlineQuestionsLoaded(bool value) => setBool('offline_questions_loaded', value);
}
