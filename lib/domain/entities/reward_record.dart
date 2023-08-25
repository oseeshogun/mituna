import 'package:mituna/core/constants/enums/all.dart';

class RewardRecord {
  final int score;
  final int duration;
  final String uid;
  final String id;
  final DateTime createdAt;
  final RewardRecordState state;

  RewardRecord({
    required this.score,
    required this.uid,
    required this.id,
    required this.duration,
    required this.createdAt,
    required this.state,
  });
}