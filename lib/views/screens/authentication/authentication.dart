import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/src/models/user_object.dart';
import 'package:mituna/src/services/auth/google.dart';
import 'package:mituna/views/screens/home/home.dart';
import 'package:mituna/views/utils/exception_dialogs.dart';
import 'package:mituna/views/widgets/all.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  static const String route = '/auth';

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  void initState() {
    super.initState();
  }

  bool get hasUser => FirebaseAuth.instance.currentUser != null;

  bool get anonymousAccountIsUsed => FirebaseAuth.instance.currentUser?.isAnonymous == true;

  @override
  Widget build(BuildContext context) {
    void initializeUserAndGoHome() {
      UserObject.initialize();
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Home.route,
          ModalRoute.withName('/'),
        );
      }
    }

    Future<void> signUserInOrLinkAccount(OAuthCredential credential) async {
      if (anonymousAccountIsUsed) {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        return;
      }
      await FirebaseAuth.instance.signInWithCredential(credential);
    }

    Future<void> connectOrContinueWithGoogle() async {
      try {
        final credential = await authenticateWithGoogle();
        await signUserInOrLinkAccount(credential);
        initializeUserAndGoHome();
      } on FirebaseException catch (e) {
        debugPrint(e.toString());
        showMessageOnFirebaseException(e, context);
      } catch (e) {
        debugPrint(e.toString());
        showMessageOnAuthenticationError(e, context);
      }
    }

    Future<void> connectOrContinueAnonymously() async {
      if (anonymousAccountIsUsed) {
        if (Navigator.canPop(context)) Navigator.of(context).pop();
        return;
      }
      try {
        await FirebaseAuth.instance.signInAnonymously();
        initializeUserAndGoHome();
      } on FirebaseException catch (e) {
        showMessageOnFirebaseException(e, context);
      } catch (e) {
        showMessageOnAuthenticationError(e, context);
      }
    }

    return WillPopScope(
      onWillPop: () async => hasUser,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                const TextTitleLevelOne(
                  'Connectez-vous pour que vos données puissent être sauvegardé',
                ),
                const Spacer(),
                PrimaryButton(
                  onPressed: () => connectOrContinueWithGoogle(),
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
                        color: kColorBlack,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  child: TextTitleLevelOne(
                    anonymousAccountIsUsed ? 'Annuler' : 'Plus tard',
                    color: kColorBlack,
                  ),
                  onPressed: () => connectOrContinueAnonymously(),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
