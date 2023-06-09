import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:uuid/uuid.dart';

class RewardRecord {
  final int score;
  final String id;
  final String uid;
  final DateTime createdAt;
  final bool fromFirebase;
  final RewardRecordState state;

  RewardRecord(
    this.score,
    this.uid, {
    String? docId,
    DateTime? date,
    this.state = RewardRecordState.queue,
    this.fromFirebase = false,
  })  : createdAt = date ?? DateTime.now(),
        id = docId ?? const Uuid().v4();

  factory RewardRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final record = RewardRecord(
      doc.data()?['score'],
      doc.data()?['uid'],
      docId: doc.id,
      date: DateTime.fromMillisecondsSinceEpoch(doc.data()?['createdAt']),
      fromFirebase: true,
      state: doc.data()?['state'] == RewardRecordState.queue.name ? RewardRecordState.queue : RewardRecordState.recorded,
    );

    if (record.state == RewardRecordState.queue) {
      record.save();
    }
    return record;
  }

  Map<String, dynamic> json() {
    return {
      'uid': uid,
      'score': score,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'state': state.name,
    };
  }

  save() {
    if (!fromFirebase) _saveToFirebase();
    _saveToDb();
  }

  _saveToFirebase() async {
    await FirebaseFirestore.instance.collection('rewards').doc(uid).collection('records').doc(id).set(json());
  }

  _saveToDb() async {
    if (state == RewardRecordState.recorded) return;
    try {
      await rewardRepository.recordReward(this);
      await FirebaseFirestore.instance
          .collection('rewards')
          .doc(uid)
          .collection('records')
          .doc(id)
          .update({'state': RewardRecordState.recorded.name});
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
