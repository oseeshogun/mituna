import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';

class LinkAnonymousAccountWithAppleUsecase extends Usecase<UserCredential?> {
  final _auth = FirebaseAuth.instance;

  AppleAuthProvider get _provider => AppleAuthProvider()
    ..addScope('email')
    ..addScope('name');

  @override
  Future<UserCredential?> execute() async {
    return await _auth.currentUser?.linkWithProvider(_provider);
  }
}

class SignInWithAppleUsecase extends Usecase<UserCredential?> {
  final _auth = FirebaseAuth.instance;

  AppleAuthProvider get _provider => AppleAuthProvider()
    ..addScope('email')
    ..addScope('name');

  @override
  Future<UserCredential?> execute() async {
    return await _auth.signInWithProvider(_provider);
  }
}
