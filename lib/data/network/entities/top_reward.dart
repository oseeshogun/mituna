import 'package:json_annotation/json_annotation.dart';

part 'top_reward.g.dart';

@JsonSerializable()
class TopRewardData {
  final int count;
  @JsonKey(name: '_id')
  final String id;

  const TopRewardData({
    required this.count,
    required this.id,
  });

  factory TopRewardData.fromJson(Map<String, dynamic> json) => _$TopRewardDataFromJson(json);
  Map<String, dynamic> toJson() => _$TopRewardDataToJson(this);
}
