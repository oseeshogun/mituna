import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mituna/core/errors/failures.dart';

class Usecase {
  Future<Either<Failure, T>> wrapper<T>(FutureOr<T> Function() execute) async {
    try {
      return Right(await execute());
    } on FirebaseException catch (err) {
      return Left(FirebaseFailure(err.message ?? 'Une erreur est inattendue est survenue.'));
    } catch (err, st) {
      debugPrint(err.toString());
      debugPrint(st.toString());
      return const Left(UnknownFailure());
    }
  }
}
