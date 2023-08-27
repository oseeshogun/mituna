import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/data/network/repositories/rewards.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/utils/file_picker/compress.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class UserUsecase extends Usecase {
  final _storage = FirebaseStorage.instance;
  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final _prefs = locator.get<SharedPreferences>();
  final _rewardsRepository = locator.get<RewardsRepository>();

  Future<Either<Failure, void>> logout() async {
    return wrapper(() async {
      await _prefs.clear();

      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserUid != null) {
        _messaging.unsubscribeFromTopic(currentUserUid);
      }
      await FirebaseAuth.instance.signOut();
    });
  }

  Future<Either<Failure, void>> deleteAccount() async {
    return wrapper(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await _rewardsRepository.deleteRewards();
      _prefs.clear();
      await _messaging.unsubscribeFromTopic(user.uid);
      await _firestore.collection('users').doc(user.uid).delete();
    });
  }

  Future<Either<Failure, void>> updateUserAvatar(String path) async {
    return wrapper(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      final xImage = await compressAndGetFile(File(path));
      final storageRef = _storage.ref();
      final basename = p.basename(xImage!.path);
      final avatarImageRef = storageRef.child('images/$basename');
      await avatarImageRef.putFile(File(xImage.path));
      final url = await avatarImageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({"avatar": url});
    });
  }

  Future<Either<Failure, void>> updateDisplayName(String displayName) async {
    return wrapper(() async {
       final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({"displayName": displayName});
    });
  }
}
