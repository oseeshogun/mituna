import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';

import 'get_google_oauth.dart';

class LinkAnonymousAccountWithGoogleUsecase extends Usecase<UserCredential?> with GetOAuthCredential {
  final _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential?> execute() async {
    final credential = await getOAuth();
    return await _auth.currentUser?.linkWithCredential(credential);
  }
}

class SignInWithGoogleUsecase extends Usecase<UserCredential?> with GetOAuthCredential {
  final _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential?> execute() async {
    final credential = await getOAuth();
    return await _auth.signInWithCredential(credential);
  }
}
