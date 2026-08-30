import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mituna/domain/entities/firestore_user.dart';

class Ranking {
  final int ranking;
  final String uid;
  final int score;
  final String displayName;
  final String avatar;
  final DateTime lastWinDate;

  Ranking({
    required this.ranking,
    required this.uid,
    required this.score,
    required this.displayName,
    required this.avatar,
    required this.lastWinDate,
  });

  factory Ranking.fromDocument(
      int ranking, DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? const {};
    return Ranking(
      ranking: ranking,
      uid: data['uid'] ?? document.id,
      score: data['score'] ?? 0,
      displayName: data['displayName'] ?? '',
      avatar: data['avatar'] ?? FirestoreUser.defaultImageUrl,
      lastWinDate: DateTime.fromMillisecondsSinceEpoch(
          data['last_time_win'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  @override
  bool operator ==(Object other) => other is Ranking && other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}
