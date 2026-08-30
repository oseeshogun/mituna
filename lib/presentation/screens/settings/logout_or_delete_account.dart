import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/usecases/auth/logout.dart';
import 'package:mituna/domain/usecases/user.dart';
import 'package:mituna/presentation/screens/auth/welcome.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

class LogoutOrDeleteAccount extends HookWidget {
  LogoutOrDeleteAccount({
    super.key,
    required this.isDeleteAccount,
  });

  final bool isDeleteAccount;

  final deleteAccountUsecase = DeleteAccountUsecase();
  final logOutUsecase = LogOutUsecase();

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    logout() {
      loading.value = true;
      logOutUsecase().then((result) {
        result.fold((l) {
          showOkAlertDialog(context: context, title: l.message);
        }, (r) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(WelcomeScreen.route, (route) => false);
        });
        loading.value = false;
      });
    }

    delete() {
      loading.value = true;
      deleteAccountUsecase().then((result) {
        result.fold((l) {
          showOkAlertDialog(context: context, title: l.message);
        }, (r) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(WelcomeScreen.route, (route) => false);
        });
        loading.value = false;
      });
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        title: TextTitleLevelTwo(
            isDeleteAccount ? 'Suppression du compte' : 'Déconnexion'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                const Spacer(),
                Lottie.asset(
                  isDeleteAccount
                      ? 'assets/lottiefiles/animation_llsr6jol.json'
                      : 'assets/lottiefiles/39138-morty-cry-loader.json',
                  height: MediaQuery.of(context).size.height * .3,
                ),
                const Spacer(),
                TextDescription(
                  isDeleteAccount
                      ? 'Voulez-vous vraiment vous supprimez votre compte?'
                      : 'Voulez-vous vraiment vous déconnecter ?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                TextDescription(
                  isDeleteAccount
                      ? '😢 Cette action est définitive. Posez-vous 5 minutes et réflechissez à ce que vous êtes sur le point de faire là. Hee ! 🙆🏾‍♂️'
                      : '😢 Ne nous quittez pas, on a besoin de vous ! S\'il vous plaît !',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Visibility(
                  visible: !loading.value,
                  replacement: const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: CircularProgressIndicator(
                        color: AppColors.kColorYellow,
                      ),
                    ),
                  ),
                  child: PrimaryButton(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: TextTitleLevelTwo(isDeleteAccount
                        ? 'Confirmer la suppression'
                        : 'Confirmer la déconnexion'),
                    onPressed: () => (isDeleteAccount ? delete() : logout()),
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
