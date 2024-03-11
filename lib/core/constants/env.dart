import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(useConstantCase: true)
abstract class Env {
  @EnviedField()
  static const String createRewardUrl = _Env.createRewardUrl;

  @EnviedField()
  static const String topRewardUrl = _Env.topRewardUrl;

  @EnviedField()
  static const String userRewardUrl = _Env.userRewardUrl;

  @EnviedField()
  static const String getQuestionOfTheDayUrl = _Env.getQuestionOfTheDayUrl;

  @EnviedField()
  static const String deleteRewardUrl = _Env.deleteRewardUrl;

  @EnviedField()
  static const String spreadsheetId = _Env.spreadsheetId;
}
