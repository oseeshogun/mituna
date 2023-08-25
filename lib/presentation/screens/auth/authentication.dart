import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/usecases/authentification.dart';
import 'package:mituna/presentation/screens/home/home.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

class AuthenticationScreen extends HookWidget {
  AuthenticationScreen({super.key});

  final authenticationUsecase = AuthenticateUserUsecase();

  static const String route = '/auth';

  bool get anonymousAccountIsUsed => FirebaseAuth.instance.currentUser?.isAnonymous == true;

  void afterAuthRedirect(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.route, (route) => false);
    }
  }

  Future<void> connectOrContinueWithGoogle(BuildContext context, ValueNotifier<bool> laoding) async {
    laoding.value = true;
    authenticationUsecase.getGoogleCredential().then((result) {
      result.fold((l) {
        showOkAlertDialog(
          context: context,
          message: l.message,
        );
        laoding.value = false;
      }, (credential) {
        authenticationUsecase.authenticateUsingGoogleCredential(credential).then((result) {
          result.fold((l) {
            showOkAlertDialog(
              context: context,
              message: l.message,
            );
            laoding.value = false;
          }, (r) {
            afterAuthRedirect(context);
          });
        });
      });
    });
  }

  Future<void> connectOrContinueAnonymously(BuildContext context, ValueNotifier<bool> laoding) async {
    if (anonymousAccountIsUsed) {
      if (Navigator.canPop(context)) return Navigator.of(context).pop();
    }
    laoding.value = true;
    authenticationUsecase.authenticateAnonymously().then((result) {
      result.fold((l) {
        showOkAlertDialog(
          context: context,
          message: l.message,
        );
        laoding.value = false;
      }, (r) {
        afterAuthRedirect(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const TextTitleLevelOne('Connectez-vous pour que vos données puissent être sauvegardé'),
              const Spacer(),
              PrimaryButton(
                onPressed: () => connectOrContinueWithGoogle(context, loading),
                loading: loading.value,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    const SizedBox(width: 20.0),
                    Image.asset(
                      'assets/icons/icons8-google-50.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                    const SizedBox(width: 10.0),
                    const TextTitleLevelTwo(
                      'Se connecter avec Google',
                      color: AppColors.kColorBlack,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                loading: loading.value,
                child: TextTitleLevelOne(
                  anonymousAccountIsUsed ? 'Annuler' : 'Plus tard',
                  color: AppColors.kColorBlack,
                ),
                onPressed: () => connectOrContinueAnonymously(context, loading),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
