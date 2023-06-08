import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/models/all.dart';

final activeCompetitionProvider = StreamProvider<Competition?>((ref) {
  return FirebaseFirestore.instance
      .collection('competitions')
      .where('finished', isEqualTo: true)
      .snapshots()
      .asyncMap((query) {
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    final data = query.docs.first.data();
    return Competition(
      id: doc.id,
      pending: data['pending'] ?? false,
      started: data['started'] ?? false,
      finished: data['finished'] ?? false,
      winner: data['winner'],
      rawQuestions:
          (data['questions'] as List).map<Map<String, dynamic>>((question) {
        return Map<String, dynamic>.from(question);
      }).toList(),
    );
  });
});

final competitionLeaderBoardProvider =
    StateProvider.family<List<CompetitionReward>, String>((ref, id) => []);
