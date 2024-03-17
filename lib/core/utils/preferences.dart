import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesKeys on SharedPreferences {
  bool get isShowLostHeartScreenAllowed => getBool('is_show_lost_heart_screen_allowed') ?? true;
  set isShowLostHeartScreenAllowed(bool value) => setBool('is_show_lost_heart_screen_allowed', value);

  double get volume => getDouble('volume') ?? 1.0;
  set volume(double value) => setDouble('volume', value > 1.0 ? min(1.0, value) : max(0.0, value));

  String get _qotdLaunchedByNofifKey => 'key_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}_qotd_launched_by_notif';

  bool get qotdLaunchedByNotif => getBool(_qotdLaunchedByNofifKey) ?? false;
  set qotdLaunchedByNotif(bool value) => setBool(_qotdLaunchedByNofifKey, value);

  bool offlineSaved(String version) => getBool('offline_$version') ?? false;
  offlineSavedDone(String version) => setBool('offline_$version', true);

  int get notificationId {
    final id = getInt('notification_id') ?? 0;
    final newId = id + 1;
    setInt('notification_id', newId);
    return newId;
  }

  bool get workCodeNotificationAction => getBool('work_code_notification_action') ?? false;
  set workCodeNotificationAction(bool value) => setBool('work_code_notification_action', value);

  int get workCodeNotificationId => getInt('work_code_notification_id') ?? 0;
  set workCodeNotificationId(int value) => setInt('work_code_notification_id', value);

  bool get randomWorkCodeArticles => getBool('random_work_code_articles') ?? false;
  set randomWorkCodeArticles(bool value) => setBool('random_work_code_articles', value);

  int get lastWorkCodeArticleId {
    final id = getInt('last_work_code_article_id') ?? 0;
    final newId = id + 1;
    setInt('last_work_code_article_id', newId);
    return newId;
  }
}
