import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'reward_record.dart';

class UserObject {
  UserObject({
    required this.uid,
    int? diamondsCount,
    String? imageUrl,
    String? name,
    bool? canShowLostHeartScreen,
    this.goodResponses = const [],
  }) {
    diamonds = diamondsCount ?? 0;
    _imageUrl = imageUrl;
    _canShowLostHeartScreen = canShowLostHeartScreen ?? true;
    displayName = name ?? 'Mutu-${uid.substring(1, 5)}';
  }

  late final int diamonds;
  late final String? _imageUrl;
  final String uid;
  late final String displayName;
  late final bool _canShowLostHeartScreen;
  final List<String> goodResponses;

  Future<void> _update(Map<String, dynamic> data) async => await FirebaseFirestore.instance.collection('users').doc(uid).update(data);

  static Future<void> initialize() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {},
      SetOptions(merge: true),
    );
  }

  factory UserObject.fromData(String uid, Map<String, dynamic> data) {
    return UserObject(
      uid: uid,
      diamondsCount: data['diamonds'],
      imageUrl: data['imageUrl'],
      name: data['displayName'],
      canShowLostHeartScreen: data['can_show_lost_screen'],
      goodResponses: List<String>.from(data['good_responses'] ?? <String>[]).toSet().toList(),
    );
  }

  void incrementTopaz(int increment, [bool saveOnDb = true]) {
    final count = diamonds + increment;
    _update({
      'diamonds': count,
      'last_time_win': DateTime.now().millisecondsSinceEpoch,
    });
    if (saveOnDb) {
      // save topaz to db online
      final reward = RewardRecord(increment, uid);
      reward.save();
    }
  }

  bool get isShowLostHeartScreenAllowed {
    if (_canShowLostHeartScreen) {
      _update({'can_show_lost_screen': false});
      return true;
    }
    return false;
  }

  static get defaultImageUrl => 'https://res.cloudinary.com/dcmzsqq2y/image/upload/v1673795782/profiles/s_udzknr.png';

  String get avatar => _imageUrl ?? defaultImageUrl;

  Future<void> updateAvatar(String url) async => await _update({'imageUrl': url});

  Future<void> updateDisplayName(String username) async => await _update({'displayName': username});

  Future<void> saveGoodResponse(String questionId) async {
    await _update({
      'good_responses': {...goodResponses, questionId}.toList()
    });
  }
}
