import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser extends Equatable {
  const FirestoreUser({
    required this.uid,
    required this.avatar,
    required this.diamonds,
    required this.displayName,
  });

  factory FirestoreUser.fromDocument(String uid,  DocumentSnapshot<Map<String, dynamic>>? document) {
    final data = document?.data();
    return FirestoreUser(
      uid: uid,
      avatar: data?['avatar'] ?? defaultImageUrl,
      diamonds: data?['diamonds'] ?? 0,
      displayName: data?['displayName'] ?? 'Aucun Nom'
    );
  }

  @override
  List<Object> get props => [uid];

  final String uid;
  final String displayName;
  final String avatar;
  final int diamonds;

  static get defaultImageUrl => 'https://res.cloudinary.com/dcmzsqq2y/image/upload/v1673795782/profiles/s_udzknr.png';
}
