import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('Une erreur est inattendue est survenue. Si le problème persiste, veuillez le notifier aux développeurs.');
}

class UnknownAuthenticationFailure extends Failure {
  const UnknownAuthenticationFailure()
      : super('Une erreur est inattendue est survenue lors de l\'authentification. Si le problème persiste, veuillez le notifier aux développeurs.');
}
