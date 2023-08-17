import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/theme/colors.dart';

import 'firebase_options.dart';
import 'locator.dart';
import 'presentation/screens/auth/authentication.dart';
import 'presentation/screens/auth/welcome.dart';
import 'presentation/screens/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();

  runApp(const ProviderScope(child: MyApp()));
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
        primaryColor: AppColors.kColorYellow,
        scaffoldBackgroundColor: AppColors.kColorBlueRibbon,
      ),
      initialRoute: initialRoute,
      routes: {
        Welcome.route: (context) => const Welcome(),
        Home.route: (context) => Home(),
        Authentication.route: (context) => Authentication(),
      },
    );
  }
}
