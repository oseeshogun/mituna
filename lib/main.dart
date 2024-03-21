import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/presentation/screens/offline_questions_load/offline_questions_load.dart';
import 'package:mituna/presentation/screens/settings/about_the_app.dart';
import 'package:mituna/presentation/screens/settings/donation.dart';
import 'package:mituna/presentation/screens/settings/favorites_categories.dart';
import 'package:mituna/presentation/screens/settings/settings.dart';

import 'firebase_options.dart';
import 'locator.dart';
import 'presentation/screens/auth/authentication.dart';
import 'presentation/screens/auth/welcome.dart';
import 'presentation/screens/home/home.dart';
import 'presentation/screens/settings/report_error.dart';

final providerContainer = ProviderContainer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();

  await locator.allReady();

  Intl.defaultLocale = 'fr';

  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isUserAuthenticated = FirebaseAuth.instance.currentUser != null;
    final initialRoute = isUserAuthenticated ? HomeScreen.route : WelcomeScreen.route;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Lato',
        primaryColor: AppColors.kColorYellow,
        scaffoldBackgroundColor: AppColors.kColorBlueRibbon,
      ),
      initialRoute: initialRoute,
      routes: {
        WelcomeScreen.route: (context) => const WelcomeScreen(),
        HomeScreen.route: (context) => HomeScreen(),
        AuthenticationScreen.route: (context) => AuthenticationScreen(),
        OfflineQuestionsLoadScreen.route: (context) => OfflineQuestionsLoadScreen(),
        SettingsScreen.route: (context) => SettingsScreen(),
        ReportErrorScreen.route: (context) => ReportErrorScreen(),
        AboutTheApp.route: (context) => const AboutTheApp(),
        Donation.route: (context) => const Donation(),
        FavoritesCategories.route: (context) => const FavoritesCategories(),
      },
    );
  }
}
