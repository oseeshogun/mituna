import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/errors/failures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mituna/core/usecase/usecase.dart';
import 'package:mituna/firebase_options.dart';

class AuthenticateUserUsecase extends Usecase {
  Future<Either<Failure, OAuthCredential>> getGoogleCredential() async {
    return wrapper(() async {
      final GoogleSignInAccount? googleUser =
          Platform.isIOS ? (await GoogleSignIn(clientId: DefaultFirebaseOptions.ios.iosClientId).signIn()) : (await GoogleSignIn().signIn());

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return credential;
    });
  }

  Future<Either<Failure, UserCredential>> authenticateAnonymously() async {
    return wrapper(() async {
      final result = await FirebaseAuth.instance.signInAnonymously();
      return result;
    });
  }

  Future<Either<Failure, UserCredential?>> authenticateUsingGoogleCredential(OAuthCredential credential) async {
    return wrapper(() async {
      if (FirebaseAuth.instance.currentUser?.isAnonymous == true) {
        return await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      }
      return await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }
}