import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mituna/views/screens/all.dart';

import 'contants/colors.dart';
import 'firebase_options.dart';
import 'locator.dart';

final providerContainer = ProviderContainer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions(dotenv).currentPlatform);

  await FirebaseAuth.instance.setLanguageCode('fr');

  setupLocator();
  await locator.allReady();

  MobileAds.instance.initialize();

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isUserAuthenticated = FirebaseAuth.instance.currentUser != null;
    final initialRoute = isUserAuthenticated ? Home.route : Welcome.route;

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
        primaryColor: kColorYellow,
        scaffoldBackgroundColor: kColorBlueRibbon,
      ),
      initialRoute: initialRoute,
      routes: {
        Welcome.route: (context) => const Welcome(),
        Home.route: (context) => const Home(),
        Authentication.route: (context) => const Authentication(),
        SprintScreen.route: (context) => const SprintScreen(),
        RankingScreen.route: (context) => const RankingScreen(),
        SettingsScreen.route: (context) => const SettingsScreen(),
        QuestionContribution.route: (context) => const QuestionContribution(),
      },
    );
  }
}
