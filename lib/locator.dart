import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/data/network/client.dart';
import 'package:mituna/data/network/repositories/question_of_the_day.dart';
import 'package:mituna/data/network/repositories/rewards.dart';
import 'package:mituna/data/network/services/create_reward.dart';
import 'package:mituna/data/network/services/delete_rewards.dart';
import 'package:mituna/data/network/services/top_rewards.dart';
import 'package:mituna/data/network/services/user_reward.dart';
import 'package:mituna/domain/services/sound_effect.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

void setupLocator() {
  final db = AppDatabase();

  locator.registerSingleton(db);
  locator.registerSingleton(QuestionsDao(db));
  locator.registerSingleton(AnswersDao(db));

  locator.registerSingleton(SoundEffects());

  locator.registerSingleton(ProviderContainer());

  final dio = client();

  locator.registerSingleton(
    RewardsRepository(
      CreateRewardService(dio),
      TopRewardService(dio),
      UserRewardService(dio),
      DeleteRewardsService(dio),
    ),
  );

  locator.registerSingleton(QuestionOfTheDayRepository());

  locator.registerSingletonAsync(() async => await SharedPreferences.getInstance());
}
