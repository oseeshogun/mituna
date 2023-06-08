import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mituna/src/models/user_object.dart';

class RankedUser {
  final String displayName;
  final String imageUrl;
  final DateTime lastTimeWin;

  RankedUser({
    required this.displayName,
    required this.imageUrl,
    required this.lastTimeWin,
  });

  factory RankedUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return RankedUser(
      lastTimeWin: doc.data()?['last_time_win'] is int ? DateTime.fromMillisecondsSinceEpoch(doc.data()?['last_time_win'] as int) : DateTime.now(),
      displayName: doc.data()?['displayName'] ?? 'Mutu-${doc.id.substring(1, 5)}',
      imageUrl: doc.data()?['imageUrl'] ?? UserObject.defaultImageUrl,
    );
  }

  @override
  String toString() {
    return {'displayName': displayName, 'imageUrl': imageUrl}.toString();
  }
}
