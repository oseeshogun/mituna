import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin GetOAuthCredential {
  Future<OAuthCredential> getOAuth() async {
    final googleSignIn = GoogleSignIn.instance;
    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

    return credential;
  }
}
