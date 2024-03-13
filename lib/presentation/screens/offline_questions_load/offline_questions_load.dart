import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/usecases/offline_load.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineQuestionsLoadScreen extends HookWidget {
  OfflineQuestionsLoadScreen({super.key});

  final offlineLoadUsecase = OfflineLoadUsecase();
  final prefs = locator.get<SharedPreferences>();

  static const route = '/offline_load';

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(seconds: 1));
    final animation = useAnimation(Tween<Alignment>(begin: Alignment.centerLeft, end: Alignment.centerRight).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    )));

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            animationController.forward();
          }
        });
        animationController.forward();

        try {
          // save questions
          await offlineLoadUsecase.saveQuestions();
          // save videos
          await offlineLoadUsecase.saveYoutubeVideos();
          // background save of workcode
        await offlineLoadUsecase.saveWorkcode();

          final info = await PackageInfo.fromPlatform();
          final version = info.version;

          prefs.offlineSavedDone(version);
          // ignore: use_build_context_synchronously
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        } catch (err, st) {
          debugPrint(err.toString());
          debugPrint(st.toString());
          showOkAlertDialog(context: context, title: 'Une erreur est survenue pendant le chargement des questions.');
          animationController.stop();
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottiefiles/37420-import-contacts.json'),
              const SizedBox(height: 30.0),
              const Text(
                'Veuillez patientez, chargement des questions...',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30.0),
              Container(
                width: MediaQuery.of(context).size.width - AppSizes.kScaffoldHorizontalPadding * 2,
                height: 10,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppColors.kColorChambray),
                child: Transform.translate(
                  offset: const Offset(0.0, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.1,
                    alignment: animation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: AppColors.kColorYellow,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 10.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
