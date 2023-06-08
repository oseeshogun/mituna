import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';

final appUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

final specificUserDataProvider =
    StreamProvider.family<RankedUser?, String>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .asyncMap((doc) => RankedUser.fromDoc(doc));
});

final rewardRecorsProvider =
    StreamProvider.family<List<RewardRecord>, String>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('rewards')
      .doc(uid)
      .collection('records')
      .where('state', isEqualTo: RewardRecordState.queue.name)
      .snapshots()
      .asyncMap((query) {
    return query.docs
        .where((doc) {
          return doc.data()['score'] is int &&
              doc.data()['uid'] is String &&
              doc.data()['createdAt'] is int;
        })
        .map((doc) => RewardRecord.fromDoc(doc))
        .toList();
  });
});

final userDataProvider = StreamProvider<UserObject?>((ref) {
  return ref.watch(appUserProvider).when(
        data: (user) {
          if (user == null) return Stream.value(null);
          return FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots()
              .asyncMap((doc) {
            final data = doc.data();
            if (data == null) return null;
            return UserObject.fromData(
              user.uid,
              data,
            );
          });
        },
        error: (error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          return Stream.value(null);
        },
        loading: () => Stream.value(null),
      );
});
