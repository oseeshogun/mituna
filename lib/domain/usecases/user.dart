import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/utils/file_picker/compress.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountUsecase extends Usecase<void> {
  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final _prefs = locator.get<SharedPreferences>();

  @override
  Future<void> execute() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).delete();
    await _messaging.unsubscribeFromTopic(user.uid);
    await _prefs.clear();
    await FirebaseAuth.instance.currentUser?.delete();
  }
}

class UpdateAvatarUsecase extends UsecaseFamily<void, String> {
  final _storage = FirebaseStorage.instance;

  @override
  Future<void> execute(String path) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final xImage = await compressAndGetFile(File(path));
    final storageRef = _storage.ref();
    final basename = p.basename(xImage!.path);
    final avatarImageRef = storageRef.child('images/$basename');
    await avatarImageRef.putFile(File(xImage.path));
    final url = await avatarImageRef.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({"avatar": url}, SetOptions(merge: true));
  }
}

class UpdateDisplayNameUsecase extends UsecaseFamily<void, String> {
  @override
  Future<void> execute(String displayName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({"displayName": displayName}, SetOptions(merge: true));
  }
}
