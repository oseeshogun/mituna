import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/competition.dart';
import 'package:mituna/src/providers/ranking.dart';
import 'package:mituna/src/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:mituna/views/arguments/competition_finished.dart';

class ApiService {
  final String baseUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ApiService(this.baseUrl);

  Future<String?> _getToken() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return await currentUser.getIdToken();
    }
    return null;
  }

  Future<dynamic> _get(String path) async {
    final url = Uri.https(baseUrl, path);
    final token = await _getToken();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return jsonDecode(response.body);
  }

  Future<dynamic> _post(String path, dynamic body) async {
    final url = Uri.https(baseUrl, path);
    final token = await _getToken();
    final response = await http.post(url, body: jsonEncode(body), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return jsonDecode(response.body);
  }

  Future<dynamic> _delete(String path) async {
    final url = Uri.https(baseUrl, path);
    final token = await _getToken();
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return jsonDecode(response.body);
  }

  Future<int> getNextCompetitionTime() async {
    final response = await _get('time');
    return response['time'];
  }

  Future<void> registerRanking(int topaz) async {
    final response = await _post('rewards/save', {'topaz': topaz});
    logger.d(response.body);
  }

  Future<void> getTopRanking(RankingPeriod period) async {
    final response = await _get('rewards/top?period=${period.name}');
    final rankings = (response as List)
        .map<Ranking>((rank) => Ranking(
              uid: rank['_id'],
              score: rank['count'],
            ))
        .toList();
    providerContainer.read(topRankingProvider(period).notifier).state = rankings;
  }

  Future<void> getMyRanking(RankingPeriod period) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final response = await _get('rewards/mine?period=${period.name}');
    final ranking = Ranking(
      uid: uid,
      score: response['score'],
      position: response['ranked'],
    );
    providerContainer.read(myRankingProvider(period).notifier).state = ranking;
  }

  Future<void> recordReward(RewardRecord reward) async {
    final data = <String, dynamic>{'topaz': reward.score, 'date': reward.createdAt.millisecondsSinceEpoch};
    final response = await _post('rewards/create', data);
    logger.d(response.body);
  }

  Future<void> recordCompetitionReward(CompetitionFinishedArguments args) async {
    if (args.topazWon == null || args.competition == null) {
      return;
    }
    final data = <String, dynamic>{'topaz': args.topazWon, 'duration': args.time, 'competitionEpoch': args.competition?.id};
    final response = await _post('competitions/reward', data);
    logger.d(response.body);
  }

  Future<List<CompetitionReward>> getCompetitionLeaderBoard(String id) async {
    final response = await _get('competitions/leaderboard?id=$id');
    final rewards = (response as List)
        .map<CompetitionReward>((record) => CompetitionReward(
              uid: record['uid'],
              topaz: record['topaz'],
              duration: record['duration'],
            ))
        .toList();
    providerContainer.read(competitionLeaderBoardProvider(id).notifier).state = rewards;
    return rewards;
  }

  Future<void> sendFeedBack(String object, String message) async {
    final currentUser = _auth.currentUser;
    final useName = currentUser?.displayName != null && currentUser?.displayName?.isNotEmpty == true;
    final data = <String, dynamic>{'name': useName ? currentUser?.displayName : 'No name', 'object': object, 'message': message};
    final response = await _post('gsheets/feedback', data);
    logger.d(response.body);
  }

  Future<void> setUserWinner(String phone) async {
    final currentUser = _auth.currentUser;
    final useName = currentUser?.displayName != null && currentUser?.displayName?.isNotEmpty == true;
    final data = <String, dynamic>{
      'name': useName ? currentUser?.displayName : 'No name',
      'phone': phone,
    };
    final response = await _post('gsheets/claim_price', data);
    logger.d(response.body);
  }

  Future<void> sendQuestionContribution(String answer, String question) async {
    final currentUser = _auth.currentUser;
    final useName = currentUser?.displayName != null && currentUser?.displayName?.isNotEmpty == true;
    final data = <String, dynamic>{'name': useName ? currentUser?.displayName : 'No name', 'question': question, 'answer': answer};
    final response = await _post('gsheets/contribution', data);
    logger.d(response.body);
  }

  Future<void> deleteRewards() async {
    final response = await _delete('rewards');
    logger.d(response.body);
  }
}
