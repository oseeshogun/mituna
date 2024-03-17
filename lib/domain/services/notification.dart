import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterNotification {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FlutterNotification() {
    const initializationSettingsAndroid = AndroidInitializationSettings('mituna');
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: initializationSettingsAndroid),
      onDidReceiveBackgroundNotificationResponse: FlutterNotification._onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: FlutterNotification._onDidReceiveNotificationResponse,
    );
  }

  Future<void> periodicNotification({
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
    required String payload,
    required int id,
    required RepeatInterval interval,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
    );
    final notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      interval,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: payload,
    );
  }

  showNotification({
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
    required String payload,
    required int id,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    final notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails, payload: payload);
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<NotificationAppLaunchDetails?> getAppLaunchedDetails() async {
    return await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  static Future<void> _onDidReceiveBackgroundNotificationResponse(NotificationResponse details) async {}
  static Future<void> _onDidReceiveNotificationResponse(NotificationResponse details) async {}
}
