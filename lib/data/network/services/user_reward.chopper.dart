// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_reward.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
final class _$UserRewardService extends UserRewardService {
  _$UserRewardService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserRewardService;

  @override
  Future<Response<List<UserRewardData>>> getUserReward(String period) {
    final Uri $url = Uri.parse('');
    final Map<String, dynamic> $params = <String, dynamic>{'period': period};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<UserRewardData>, UserRewardData>($request);
  }
}
