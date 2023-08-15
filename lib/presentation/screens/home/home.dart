import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends HookWidget {
  Home({super.key});

  final messaging = FirebaseMessaging.instance;

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {

    useEffect(() {
      messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
      return null;
    }, []);


    return const Placeholder();
  }
}
