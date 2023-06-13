import 'package:get_it/get_it.dart';
import 'package:mituna/objectbox.g.dart';
import 'package:mituna/src/db/repositories/answer.dart';
import 'package:mituna/src/db/repositories/question.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/services/hive/hive_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'src/services/sound_effect.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {

  final store = await openStore(directory: path.join((await getApplicationDocumentsDirectory()).path, "obx-mituna"));
  
  // hive
  locator.registerLazySingletonAsync<HiveDatabase>(() async {
    return await HiveDatabase.initialize();
  });

  // sournd effects
  locator.registerSingleton<SoundEffects>(SoundEffects());

  // repositories
  locator.registerLazySingleton<QuestionRepository>(() => QuestionRepository.create(store));
  locator.registerLazySingleton<AnswerRepository>(() => AnswerRepository.create(store));
  locator.registerLazySingleton<ApiRepository>(() => ApiRepository());
  locator.registerLazySingleton<RewardsRepository>(() => RewardsRepository());
  locator.registerLazySingleton<CompetitionRepository>(() => CompetitionRepository());
  locator.registerLazySingleton<GheetRepository>(() => GheetRepository());
}
