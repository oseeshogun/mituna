import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

showMessageOnFirebaseException(FirebaseException err, BuildContext context) {
  showOkAlertDialog(
    context: context,
    title: 'Une erreur est survenue',
    message: err.message,
  );
}

showMessageOnAuthenticationError(Object err, BuildContext context) {
  showOkAlertDialog(
    context: context,
    message: 'Une erreur est inattendue est survenue lors de l\'authentification. Si le problème persiste, veuillez le notifier aux développeurs.',
  );
}

showMessageError(Object err, BuildContext context) {
  showOkAlertDialog(
    context: context,
    message: 'Une erreur est inattendue est survenue. Si le problème persiste, veuillez le notifier aux développeurs.',
  );
}
