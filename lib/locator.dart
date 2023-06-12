import 'package:get_it/get_it.dart';
import 'package:mituna/src/db/repositories/question.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/services/hive/hive_db.dart';

import 'src/services/sound_effect.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  
  // hive
  locator.registerLazySingletonAsync<HiveDatabase>(() async {
    return await HiveDatabase.initialize();
  });

  // sournd effects
  locator.registerLazySingleton<SoundEffects>(() => SoundEffects());

  // repositories
  locator.registerLazySingletonAsync<QuestionRepository>(() async {
    return await QuestionRepository.create();
  });
  locator.registerLazySingleton<ApiRepository>(() => ApiRepository());
  locator.registerLazySingleton<RewardsRepository>(() => RewardsRepository());
  locator.registerLazySingleton<CompetitionRepository>(() => CompetitionRepository());
  locator.registerLazySingleton<GheetRepository>(() => GheetRepository());
}
