import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/usecases/sprint.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/main.dart';
import 'package:mituna/presentation/screens/sprint/sprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

(bool, void Function()) useSetupInteractedMessage(BuildContext context) {
  final _messaging = FirebaseMessaging.instance;
  final _sprintUsecase = SprintUsecase();
  final _prefs = locator.get<SharedPreferences>();

  final isLoadingTodayQuestion = useState<bool>(false);

  void todayQuestion() {
    isLoadingTodayQuestion.value = true;
    _sprintUsecase.sprintQuestionOfTheDay().then((result) {
      result.fold((l) {
        showOkAlertDialog(context: context, title: l.message);
      }, (sprint) {
        providerContainer.read(sprintHeartsProvider(sprint.id).notifier).update(sprint.hearts);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SprintScreen(sprint)));
      });
      isLoadingTodayQuestion.value = false;
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'question_of_the_day' && !_prefs.qotdLaunchedByNotif) {
      todayQuestion();
      _prefs.qotdLaunchedByNotif = true;
    }
  }

  setup() async {
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  useEffect(() {
    _messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
    _messaging.subscribeToTopic('question_of_the_day');
    return null;
  }, []);

  useEffect(() {
    setup();
    return null;
  }, []);

  return (isLoadingTodayQuestion.value, todayQuestion);
}
