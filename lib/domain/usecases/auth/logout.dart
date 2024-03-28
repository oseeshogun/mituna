import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutUsecase extends Usecase<void> {
  final _messaging = FirebaseMessaging.instance;
  final _prefs = locator.get<SharedPreferences>();

  @override
  Future<void> execute() async {
    await _prefs.clear();

    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      _messaging.unsubscribeFromTopic(currentUserUid);
    }
    await FirebaseAuth.instance.signOut();
  }
}
