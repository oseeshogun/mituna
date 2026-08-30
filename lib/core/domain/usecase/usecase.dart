import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/domain/errors/firebase_exception_message_fr.dart';

const _userCancellationAuthCodes = {
  'canceled',
  'cancelled',
  'web-context-canceled',
  'web-context-cancelled',
  'user-cancelled',
  'ERROR_ABORTED_BY_USER',
};

bool _isUserCancellation(Object err) {
  if (err is GoogleSignInException) {
    return err.code == GoogleSignInExceptionCode.canceled;
  }
  if (err is FirebaseAuthException) {
    return _userCancellationAuthCodes.contains(err.code);
  }
  return false;
}

mixin _ErrorWrapper<T> {
  final logger = Logger();

  Future<Either<Failure, T>> wrapper(Future<T> Function() execute) async {
    try {
      return Right<Failure, T>(await execute.call());
    } catch (err, st) {
      logger.w("_ErrorWrapper:$err");
      logger.w("_ErrorWrapper\n:$st");
      return _resolveLeft(err, st);
    }
  }

  Either<Failure, T> syncWrapper(T Function() execute) {
    try {
      return Right<Failure, T>(execute.call());
    } catch (err, st) {
      logger.w("_ErrorWrapper:$err");
      logger.w("_ErrorWrapper\n:$st");
      return _resolveLeft(err, st);
    }
  }

  Either<Failure, T> _resolveLeft(Object err, StackTrace st) {
    if (_isUserCancellation(err)) {
      return Left(CancelledByUserFailure(
          err is Exception ? err : Exception(err.toString())));
    }
    if (err is FirebaseAuthException) {
      return Left(FirebaseFailure(
          err.messageFr ?? 'Une erreur est inattendue est survenue.', err));
    } else if (err is FirebaseException) {
      return Left(FirebaseFailure(
          err.messageFr ?? 'Une erreur est survenue au niveau de firebase.',
          err));
    }

    return Left(UnknownFailure(err as Exception));
  }
}

abstract class SyncUsecase<T> with _ErrorWrapper<T> {
  Either<Failure, T> call() => syncWrapper((() => execute()));

  T execute();
}

abstract class Usecase<T> with _ErrorWrapper<T> {
  Future<Either<Failure, T>> call() async => await wrapper((() => execute()));

  Future<T> execute();
}

abstract class SyncUsecaseFamily<T, R> with _ErrorWrapper<T> {
  Either<Failure, T> call(R param) => syncWrapper((() => execute(param)));

  T execute(R param);
}

abstract class UsecaseFamily<T, R> with _ErrorWrapper<T> {
  Future<Either<Failure, T>> call(R param) async {
    return await wrapper(() => execute(param));
  }

  Future<T> execute(R param);
}
