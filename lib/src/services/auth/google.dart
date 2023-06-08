import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<OAuthCredential> authenticateWithGoogle() async {
  final GoogleSignInAccount? googleUser = Platform.isIOS
      ? (await GoogleSignIn(clientId: dotenv.env['FIREBASE_ANDROID_CLIENT_ID']).signIn())
      : (await GoogleSignIn().signIn());

  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return credential;
}
