import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(Request request, Response response, [Request? originalRequest]) async {
    final headers = request.headers;
    headers.addEntries([MapEntry('Authorization', await FirebaseAuth.instance.currentUser?.getIdToken() ?? '')]);
    return request.copyWith();
  }
}
