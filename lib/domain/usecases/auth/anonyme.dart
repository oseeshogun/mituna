import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';

class AnonymeAuthentificationUsecase extends Usecase<UserCredential> {
  final _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> execute() {
    return _auth.signInAnonymously();
  }
}
