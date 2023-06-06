import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/db/repositories/question.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'contants/colors.dart';
import 'firebase_options.dart';

final providerContainer = ProviderContainer();
late final QuestionRepository questionRepository;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  questionRepository = await QuestionRepository.create();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions(dotenv).currentPlatform);

  await FirebaseAuth.instance.setLanguageCode('fr');

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
    // final isUserAuthenticated = FirebaseAuth.instance.currentUser != null;
    // final initialRoute = isUserAuthenticated ? Home.route : Welcome.route;

    return MaterialApp(
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
      home: const Placeholder(),
    );
  }
}
