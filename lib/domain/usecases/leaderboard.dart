import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/domain/entities/firestore_user.dart';

/// Writes the given user's current profile and score into the public
/// `leaderboard/{uid}` document, reading the fresh totals from their
/// `users/{uid}` document. Callers are responsible for excluding
/// anonymous accounts.
Future<void> publishLeaderboardEntry(String uid) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final user = FirestoreUser.fromDocument(uid, snapshot);
  await FirebaseFirestore.instance.collection('leaderboard').doc(uid).set(
    {
      'uid': uid,
      'score': user.diamonds,
      'displayName': user.displayName,
      'avatar': user.avatar,
      'last_time_win': user.lastWinDate.millisecondsSinceEpoch,
    },
    SetOptions(merge: true),
  );
}

/// Publishes the signed-in (non-anonymous) user's leaderboard entry now,
/// instead of waiting for their next sprint win. Used right after a guest
/// account is linked to a real provider.
class SyncMyLeaderboardEntryUsecase extends Usecase<void> {
  @override
  Future<void> execute() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null || firebaseUser.isAnonymous) return;
    await publishLeaderboardEntry(firebaseUser.uid);
  }
}
