import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/db/repositories/question.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/http/repositories/gsheet_repository.dart';
import 'package:mituna/src/services/hive/hive_db.dart';
import 'package:mituna/src/services/sound_effect.dart';

import 'contants/colors.dart';
import 'firebase_options.dart';

final providerContainer = ProviderContainer();
late final QuestionRepository questionRepository;
late final HiveDatabase hiveDatabase;
late final SoundEffects soundEffect;
late final ApiRepository apiRepository;
late final RewardsRepository rewardRepository;
late final CompetitionRepository competitionRepository;
late final GheetRepository gheetRepository;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  questionRepository = await QuestionRepository.create();

  hiveDatabase = await HiveDatabase.initialize();

  soundEffect = SoundEffects(hiveDatabase);

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions(dotenv).currentPlatform);

  await FirebaseAuth.instance.setLanguageCode('fr');

  apiRepository = ApiRepository();
  rewardRepository = RewardsRepository();
  competitionRepository = CompetitionRepository();
  gheetRepository = GheetRepository();

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
