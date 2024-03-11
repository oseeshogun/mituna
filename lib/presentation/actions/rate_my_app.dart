import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rate_my_app/rate_my_app.dart';

void useRateMyApp(BuildContext context) {
  useEffect(() {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: 'deepcolt.com.mituna',
    );

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Notez cette application',
          message:
              "Si vous aimez cette application, veuillez prendre un petit moment pour laisser un avis ! Cela nous aide vraiment et cela ne devrait pas vous prendre plus d'une minute.",
          rateButton: 'NOTEZ',
          noButton: 'NON MERCI',
          laterButton: 'PLUS TARD',
          ignoreNativeDialog: Platform.isAndroid,
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });

    return null;
  }, []);
}
