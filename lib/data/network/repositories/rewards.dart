import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/data/network/entities/top_reward.dart';
import 'package:mituna/data/network/entities/user_reward.dart';
import 'package:mituna/data/network/services/create_reward.dart';
import 'package:mituna/data/network/services/top_rewards.dart';
import 'package:mituna/data/network/services/user_reward.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

class RewardsRepository {
  Future<Dio> _client() async {
    final dio = Dio();
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        error: true,
        compact: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
    return dio;
  }

  Future<HttpResponse<dynamic>> create({
    required int topaz,
    required int duration,
    required DateTime date,
  }) async {
    final createRewardService = CreateRewardService(await _client());

    return createRewardService.createReward(topaz, duration, date.toIso8601String());
  }

  Future<HttpResponse<List<TopRewardData>>> getTopRewards([RankingPeriod period = RankingPeriod.all]) async {
    final topRewardService = TopRewardService(await _client());

    return topRewardService.getTopRewards(period.name);
  }

  Future<HttpResponse<UserRewardData>> getUserReward([RankingPeriod period = RankingPeriod.all]) async {
    final userRewardService = UserRewardService(await _client());

    return userRewardService.getUserReward(period.name);
  }
}
