import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mituna/firebase_options.dart';

mixin GetOAuthCredential {
  Future<OAuthCredential> getOAuth() async {
    final GoogleSignInAccount? googleUser =
        Platform.isIOS ? (await GoogleSignIn(clientId: DefaultFirebaseOptions.ios.iosClientId).signIn()) : (await GoogleSignIn().signIn());

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return credential;
  }
}
