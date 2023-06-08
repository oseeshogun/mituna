import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static const String userBoxName = 'user';

  final Box<dynamic> userBox;

  HiveDatabase._create({required this.userBox});

  static Future<HiveDatabase> initialize() async {
    await Hive.initFlutter();

    final Box userBox = await Hive.openBox(userBoxName);

    final HiveDatabase hiveObject = HiveDatabase._create(userBox: userBox);
    return hiveObject;
  }

  double getVolume(Box box) {
    return box.get('volume', defaultValue: 1.0);
  }

  bool shouldShowLostHeartScreen(Box box) {
    return box.get('show_lost_heart', defaultValue: true);
  }

  void setShowLostHeartScreen(bool value) {
    userBox.put('show_lost_heart', value);
  }

  double get volume {
    return getVolume(userBox);
  }

  void setVolume(double volume) {
    userBox.put('volume', volume);
  }

  void clear() {
    userBox.clear();
  }
}
