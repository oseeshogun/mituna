import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/entities/reward_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking.g.dart';

@riverpod
class RankingsNotifier extends _$RankingsNotifier {
  @override
  List<Ranking> build(String period) => [];

  void preppendAll(List<Ranking> value) {
    state = [...value, ...state].toSet().toList();
  }

  void appendAll(List<Ranking> value) {
    state = [...state, ...value].toSet().toList();
  }
}

@riverpod
Stream<List<RewardRecord>> userRewardsQueued(UserRewardsQueuedRef ref, String uid) {
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
}
