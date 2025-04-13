import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/sprint_hearts.dart';
import 'package:mituna/domain/usecases/sprint.dart';
import 'package:mituna/presentation/actions/firebase_messaging.dart';
import 'package:mituna/presentation/actions/offline_save.dart';
import 'package:mituna/presentation/actions/rate_my_app.dart';
import 'package:mituna/presentation/screens/home/categories.dart';
import 'package:mituna/presentation/screens/settings/settings.dart';
import 'package:mituna/presentation/screens/sprint/sprint.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final messaging = FirebaseMessaging.instance;

  final startSprintUsecase = StartSprintUsecase();

  static const String route = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useRateMyApp(context);
    useOfflineSave(context);
    useSetupInteractedMessage(context);

    startPrint([QuestionCategory? category]) async {
      startSprintUsecase(category).then((result) {
        result.fold((l) {
          showOkAlertDialog(
            context: context,
            message: l.message,
          );
        }, (sprint) {
          ref.watch(sprintHeartsProvider(sprint.id).notifier).update(sprint.hearts);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => SprintScreen(sprint)));
        });
      });
    }

    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Opacity(
                      opacity: 0.5,
                      child: Lottie.asset(
                        'assets/lottiefiles/bells.json',
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pushNamed(SettingsScreen.route),
                              icon: const Icon(
                                CupertinoIcons.settings,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      FadeAnimation(
                        delay: 1.0,
                        child: RunningManLottieButton(onPressed: () => startPrint()),
                      ),
                      const SizedBox(height: 20.0),
                      const TextTitleLevelOne('Appuyez pour commencer'),
                      const SizedBox(height: 30.0),
                      QuestionCategoriesHomeList(startPrint: startPrint),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/svgs/openai-white-logomark.svg',
                            height: 40.0,
                            width: 40.0,
                          ),
                          const SizedBox(width: 10.0),
                          TextTitleLevelTwo('Powered by ChatGPT API'),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.translate(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
