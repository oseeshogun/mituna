import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';

class FirestoreUser extends Equatable {
  final String uid;
  final String displayName;
  final String avatar;
  final DateTime lastWinDate;

  const FirestoreUser({
    required this.uid,
    required this.avatar,
    required this.displayName,
    required this.lastWinDate,
  });

  factory FirestoreUser.fromDocument(String uid, DocumentSnapshot<Map<String, dynamic>>? document) {
    final data = document?.data();
    return FirestoreUser(
        uid: uid,
        avatar: data?['avatar'] ?? defaultImageUrl,
        displayName: data?['displayName'] ?? faker.person.firstName(),
        lastWinDate: DateTime.fromMillisecondsSinceEpoch(data?['last_time_win'] ?? DateTime.now().millisecondsSinceEpoch));
  }

  @override
  List<Object> get props => [uid];

  static get defaultImageUrl => 'https://res.cloudinary.com/dcmzsqq2y/image/upload/v1673795782/profiles/s_udzknr.png';
}
