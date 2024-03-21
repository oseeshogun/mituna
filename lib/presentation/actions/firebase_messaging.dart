import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useSetupInteractedMessage(BuildContext context) {
  final _messaging = FirebaseMessaging.instance;

  useEffect(() {
    _messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
    return null;
  }, []);
}
