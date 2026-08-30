import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// `GoogleSignIn` 7.x requires [GoogleSignIn.initialize] to run exactly once
/// before any other call. Memoised so concurrent callers share it; cleared on
/// failure so a later attempt can retry.
Future<void>? _googleSignInInitialization;

Future<void> _ensureGoogleSignInInitialized() {
  return _googleSignInInitialization ??=
      GoogleSignIn.instance.initialize().catchError((Object error) {
    _googleSignInInitialization = null;
    throw error;
  });
}

mixin GetOAuthCredential {
  Future<OAuthCredential> getOAuth() async {
    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential =
        GoogleAuthProvider.credential(idToken: googleAuth.idToken);

    return credential;
  }
}
