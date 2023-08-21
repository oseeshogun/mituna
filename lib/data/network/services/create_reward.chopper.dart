// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reward.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
final class _$CreateRewardService extends CreateRewardService {
  _$CreateRewardService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CreateRewardService;

  @override
  Future<Response<dynamic>> createReward(
    int topaz,
    int duration,
    String date,
  ) {
    final Uri $url = Uri.parse('');
    final $body = <String, dynamic>{
      'topaz': topaz,
      'duration': duration,
      'date': date,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
