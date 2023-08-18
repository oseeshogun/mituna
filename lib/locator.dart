import 'package:get_it/get_it.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

void setupLocator() {
  final db = AppDatabase();

  locator.registerSingleton(db);
  locator.registerSingleton(QuestionsDao(db));
  locator.registerSingleton(AnswersDao(db));
  
  locator.registerSingletonAsync(() async => await SharedPreferences.getInstance());
}
