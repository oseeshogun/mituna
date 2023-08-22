import 'package:json_annotation/json_annotation.dart';

part 'user_reward.g.dart';

@JsonSerializable()
class UserRewardData {
  final int ranked;
  final int score;

  const UserRewardData({
    required this.ranked,
    required this.score,
  });

  factory UserRewardData.fromJson(Map<String, dynamic> json) => _$UserRewardDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserRewardDataToJson(this);
}
