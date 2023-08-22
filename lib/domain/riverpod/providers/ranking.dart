import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/entities/reward_record.dart';

final rankingsProvider = StateProvider.family<List<Ranking>, String>((ref, period) => []);

final userRewardsQueuedProvider = StreamProvider.family<List<RewardRecord>, String>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('rewards')
      .doc(uid)
      .collection('records')
      .where('state', isEqualTo: RewardRecordState.queue.name)
      .snapshots()
      .asyncMap((query) {
    return query.docs
        .where((doc) {
          return doc.data()['score'] is int && doc.data()['uid'] is String && doc.data()['createdAt'] is int;
        })
        .map(
          (doc) => RewardRecord(
            id: doc.id,
            uid: uid,
            score: doc.data()['score'],
            duration: doc.data()['duration'] ?? 0,
            state: doc.data()['state'] == RewardRecordState.queue.name ? RewardRecordState.queue : RewardRecordState.recorded,
            createdAt: DateTime.fromMillisecondsSinceEpoch(doc.data()['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
          ),
        )
        .toList();
  });
});
