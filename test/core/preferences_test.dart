import 'package:flutter_test/flutter_test.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final SharedPreferences prefs;
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('Shared Preferences Volume Extension', () {
    test('Volume between 0.0 and 1.0', () {
      prefs.volume = 4;
      expect(prefs.volume, 1.0, reason: "Volume be must be less or equal to 1.0");
    });

    test('Volume between 0.0 and 1.0', () {
      prefs.volume = -2.0;
      expect(prefs.volume, 0.0, reason: "Volume be must be upper or equal to 0.0");
    });

    test('Volume setter must be the same than the getter', () {
      prefs.volume = 0.5;
      expect(prefs.volume, 0.5, reason: "Volume settter is not the same than the getter");
    });
  });

  group('Shared Preferences offline question loaded', () {
    test('Default value', () {
      expect(prefs.offlineQuestionsLoaded, false);
    });

    test('Setter Match getter', () {
      prefs.offlineQuestionsLoaded = true;
      expect(prefs.offlineQuestionsLoaded, true);

      prefs.offlineQuestionsLoaded = false;
      expect(prefs.offlineQuestionsLoaded, false);
    });
  });

  group('Shared Preferences show lost screen', () {
    test('Default value', () {
      expect(prefs.isShowLostHeartScreenAllowed, true);
    });

    test('Setter Match getter', () {
      prefs.isShowLostHeartScreenAllowed = false;
      expect(prefs.offlineQuestionsLoaded, false);

      prefs.isShowLostHeartScreenAllowed = true;
      expect(prefs.isShowLostHeartScreenAllowed, true);
    });
  });
}
