import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/preferences.dart';
import 'package:mituna/core/theme/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/riverpod/providers/user.dart';
import 'package:mituna/presentation/screens/offline_questions_load/offline_questions_load.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final prefs = locator.get<SharedPreferences>();
  
  final messaging = FirebaseMessaging.instance;

  static const String route = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreAuthUserStreamProvider = ref.watch(firestoreAuthenticatedUserStreamProvider);

    useEffect(() {
      messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
      return null;
    }, []);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!prefs.offlineQuestionsLoaded) {
          Navigator.of(context).pushNamed(OfflineQuestionsLoadScreen.route);
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const TopazIcon(),
                    const SizedBox(width: 5.0),
                    firestoreAuthUserStreamProvider.when(
                      loading: () => TextTitleLevelTwo(0.toString()),
                      error: (error, stackTrace) => TextTitleLevelTwo(0.toString()),
                      data: (firestoreAuthUser) => TextTitleLevelTwo(firestoreAuthUser?.diamonds.toString() ?? 0.toString()),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => throw UnimplementedError("Add route to settings"),
                      icon: const Icon(
                        CupertinoIcons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                FadeAnimation(
                  delay: 1.0,
                  child: RunningManLottieButton(onPressed: () => throw UnimplementedError('Should start print')),
                ),
                const SizedBox(height: 30.0),
                Transform.translate(
                  offset: const Offset(AppSizes.kScaffoldHorizontalPadding, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/jaguar-42010_640.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * .5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
