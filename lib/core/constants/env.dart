import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'CREATE_REWARD_URL')
  static const String createRewardUrl = _Env.createRewardUrl;

  @EnviedField(varName: 'TOP_REWARD_URL')
  static const String topRewardUrl = _Env.topRewardUrl;

  @EnviedField(varName: 'USER_REWARD_URL')
  static const String userRewardUrl = _Env.userRewardUrl;

  @EnviedField(varName: 'GET_QUESTION_OF_THE_DAY_URL')
  static const String getQuestionOfTheDayUrl = _Env.getQuestionOfTheDayUrl;

  @EnviedField(varName: 'DELETE_REWARD_URL')
  static const String deleteRewardUrl = _Env.deleteRewardUrl;

  @EnviedField(varName: 'SPREADSHEET_ID')
  static const String spreadsheetId = _Env.spreadsheetId;
}
