import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/src/utils/logger.dart';
import 'package:mituna/views/screens/sprint/sprint.dart';

import '../competition/claim_price.dart';
import '../ranking/global_ranking.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription? authStateListener;
  ProviderSubscription<AsyncValue<List<RewardRecord>>>? recordsListener;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authStateListener = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) return;
        recordsListener?.close();
        recordsListener = rewardRecorsProvider(user.uid).addListener(
          providerContainer,
          (previous, next) {
            debugPrint('${next.value?.length} records not saved !!!');
          },
          onError: (err, stack) {
            logger.e(err);
            logger.e(stack);
          },
          onDependencyMayHaveChanged: () {},
          fireImmediately: true,
        );

        // set
        final messaging = FirebaseMessaging.instance;
        messaging.subscribeToTopic('competition');

        final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

        if (currentUserUid != null) {
          messaging.subscribeToTopic(currentUserUid);
        }

        if (Platform.isIOS) {
          messaging
              .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          )
              .then((settings) {
            debugPrint('User granted permission: ${settings.authorizationStatus}');
          }).catchError((err) {
            debugPrint(err.toString());
          });
        }
      });
    });
  }

  @override
  void dispose() {
    authStateListener?.cancel();
    recordsListener?.close();
    super.dispose();
  }

  void startSprint({QuestionCategory? category, List<String>? goodResponses}) {
    providerContainer.read(sprintProvider.notifier).state = Sprint(
      category: category,
      goodAnswers: goodResponses ?? [],
    );
    Navigator.of(context).pushNamed(SprintScreen.route);
  }

  void showClassment() {
    Navigator.of(context).pushNamed(RankingScreen.route);
  }

  void claimPrice() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ClaimPrice(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
