// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_rewards.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
final class _$TopRewardService extends TopRewardService {
  _$TopRewardService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = TopRewardService;

  @override
  Future<Response<List<TopRewardData>>> getTopRewards(String period) {
    final Uri $url = Uri.parse('');
    final Map<String, dynamic> $params = <String, dynamic>{'period': period};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<TopRewardData>, TopRewardData>($request);
  }
}
