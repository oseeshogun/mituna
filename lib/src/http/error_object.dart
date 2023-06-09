import 'package:equatable/equatable.dart';

import 'failures.dart';

class ErrorObject extends Equatable {
  const ErrorObject({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  static const String clientHelpEmail = 'omasuaku@gmail.com';

  @override
  List<Object?> get props => [title, message];

  /// Again, here I leverage the power of sealed_classes to write robust code and
  /// make sure to map evey and each failure with a specific message to show in
  /// the UI.
  static ErrorObject mapFailureToErrorObject({required FailureEntity failure}) {
    return failure.when(
      serverFailure: () => const ErrorObject(
        title: 'Error Code: INTERNAL_SERVER_FAILURE',
        message:
            'Il semble que le serveur ne soit pas joignable pour le moment, essayez '
            "plus tard, si le problème persiste, veuillez contacter l'équipe d'assistance à la clientèle. "
            "à l'adresse $clientHelpEmail",
      ),
      dataParsingFailure: () => const ErrorObject(
        title: 'Error Code: JSON_PARSING_FAILURE',
        message:
            "Il semble que l'application doive être mise à jour pour refléter le , "
            "structure de données du serveur modifiée, si aucune mise à jour n'est "
            "disponible sur le store, veuillez contacter le développeur à l'adresse $clientHelpEmail.",
      ),
      noConnectionFailure: () => const ErrorObject(
        title: 'Error Code: NO_CONNECTIVITY',
        message: 'Il semble que votre appareil ne soit pas connecté au réseau, '
            'veuillez vérifier votre connectivité internet ou réessayer plus tard.',
      ),
      unauthorizedFailure: () => const ErrorObject(
        title: 'Error Code: UNAUTHORIZED',
        message: "Vous n'êtes pas autorisé à effectuer cette action, "
            "veuillez vous connecter et réessayer.",
      ),
      unknownFailure: () => const ErrorObject(
        title: 'Error Code: UNKNOWN',
        message: "Pour des raisons inconnues, cette rêquete n'a pu"
            "être complétée.",
      ),
    );
  }
}
