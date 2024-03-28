import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/local/repositories/answer_repository_impl.dart';
import 'package:mituna/data/local/repositories/question_repository_impl.dart';
import 'package:mituna/domain/repositories/answer_repository.dart';
import 'package:mituna/domain/repositories/question_repository.dart';
import 'package:mituna/domain/services/sound_effect.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

void setupLocator() {
  final db = AppDatabase();

  locator.registerSingleton(db);
  locator.registerSingleton(QuestionsDao(db));
  locator.registerSingleton(AnswersDao(db));

  locator.registerSingleton<AnswerRepository>(AnswerRepositoryImpl());
  locator.registerSingleton<QuestionRepository>(QuestionRepositoryImpl());

  locator.registerSingleton(SoundEffects());

  locator.registerSingleton(ProviderContainer());

  locator.registerSingletonAsync(() async => await SharedPreferences.getInstance());
}
