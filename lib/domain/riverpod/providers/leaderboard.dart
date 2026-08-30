import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaderboard.g.dart';

const _leaderboardLimit = 30;

/// Top players, all-time, ordered by score. Cached until explicitly
/// invalidated (pull-to-refresh / the app bar refresh action) so opening
/// the ranking screen repeatedly does not re-bill 30 reads each time.
@Riverpod(keepAlive: true)
Future<List<Ranking>> leaderboardTop(Ref ref) async {
  final query = await FirebaseFirestore.instance
      .collection('leaderboard')
      .orderBy('score', descending: true)
      .limit(_leaderboardLimit)
      .get();

  return query.docs
      .asMap()
      .entries
      .map((entry) => Ranking.fromDocument(entry.key + 1, entry.value))
      .toList();
}

/// The authenticated user's rank as "number of players with a strictly
/// higher score, plus one", computed with a Firestore aggregation query
/// (one billed read, no documents downloaded). `null` when the user is
/// anonymous or has not scored yet.
@Riverpod(keepAlive: true)
Future<int?> myLeaderboardRank(Ref ref) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null || firebaseUser.isAnonymous) return null;

  final user = await ref.watch(firestoreAuthenticatedUserStreamProvider.future);
  if (user == null || user.diamonds <= 0) return null;

  final higher = await FirebaseFirestore.instance
      .collection('leaderboard')
      .where('score', isGreaterThan: user.diamonds)
      .count()
      .get();

  return (higher.count ?? 0) + 1;
}
