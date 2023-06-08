import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/models/sprint.dart';

final sprintProvider = StateProvider<Sprint?>((ref) => null);

final sprintHeartsProvider =
    StateProvider.family<int, String>((ref, sprintId) => 0);

final competitionProvider = StreamProvider<Competition?>((ref) {
  return FirebaseFirestore.instance
      .collection('competitions')
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
