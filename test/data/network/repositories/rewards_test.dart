import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:mituna/data/network/entities/user_reward.dart';
import 'package:mituna/data/network/repositories/rewards.dart';
import 'package:mituna/data/network/services/create_reward.dart';
import 'package:mituna/data/network/services/delete_rewards.dart';
import 'package:mituna/data/network/services/top_rewards.dart';
import 'package:mituna/data/network/services/user_reward.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';

import 'rewards_test.mocks.dart';

@GenerateMocks([CreateRewardService, TopRewardService, UserRewardService, DeleteRewardsService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RewardsRepository rewardsRepository;
  final createRewardService = MockCreateRewardService();
  final topRewardService = MockTopRewardService();
  final userRewardService = MockUserRewardService();
  final deleteRewardsService = MockDeleteRewardsService();

  setUp(() async {
    rewardsRepository = RewardsRepository(
      createRewardService,
      topRewardService,
      userRewardService,
      deleteRewardsService,
    );
  });

  test('Create reward', () async {
    when(createRewardService.createReward(any, any, any)).thenAnswer(
      (_) async => HttpResponse({}, Response(requestOptions: RequestOptions(), statusCode: 201)),
    );

    final result = await rewardsRepository.create(
      topaz: 10,
      duration: 60,
      date: DateTime.now(),
    );

    expect(result.response.statusCode, 201);
  });

  test('Get user reward', () async {
    when(userRewardService.getUserReward(any)).thenAnswer(
      (_) async => HttpResponse(UserRewardData(ranked: 10, score: 5), Response(requestOptions: RequestOptions(), statusCode: 200)),
    );

    final result = await rewardsRepository.getUserReward(RankingPeriod.all);

    expect(result.response.statusCode, 200);
    expect(result.data.ranked, 10);
  });

  test('Top rewards', () async {
    when(topRewardService.getTopRewards(any)).thenAnswer(
      (_) async => HttpResponse([
        TopRewardData(count: 1, id: 'user-random1'),
        TopRewardData(count: 2, id: 'user-random2'),
      ], Response(requestOptions: RequestOptions(), statusCode: 200)),
    );

    final result = await rewardsRepository.getTopRewards(RankingPeriod.all);

    expect(result.response.statusCode, 200);
    expect(result.data.runtimeType, List<TopRewardData>);
  });

  test('Top rewards', () async {
    when(deleteRewardsService.deleteRewards()).thenAnswer(
      (_) async => HttpResponse(null, Response(requestOptions: RequestOptions(), statusCode: 200)),
    );

    final result = await rewardsRepository.deleteRewards();

    expect(result.response.statusCode, 200);
  });
}
