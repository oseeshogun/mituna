import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final Exception exception;
  const Failure(this.message, this.exception);

  @override
  List<Object> get props => [message];
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message, super.exception);
}

class UnknownFailure extends Failure {
  const UnknownFailure(Exception exception)
      : super('Une erreur inattendue est survenue. Si le problème persiste, veuillez le notifier aux développeurs.', exception);
}

class UnknownAuthenticationFailure extends Failure {
  const UnknownAuthenticationFailure(Exception exception)
      : super('Une erreur inattendue est survenue lors de l\'authentification. Si le problème persiste, veuillez le notifier aux développeurs.', exception);
}
