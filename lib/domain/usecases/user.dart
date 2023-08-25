import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/presentation/utils/file_picker/compress.dart';
import 'package:path/path.dart' as p;

class UserUsecase extends Usecase {
  final _storage = FirebaseStorage.instance;

  Future<Either<Failure, void>> updateUserAvatar(String path) async {
    return wrapper(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      final xImage = await compressAndGetFile(File(path));
      final storageRef = _storage.ref();
      final basename = p.basename(xImage!.path);
      final avatarImageRef = storageRef.child('images/$basename');
      await avatarImageRef.putFile(File(xImage.path));
      final url = await avatarImageRef.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({"avatar": url});
    });
  }
}
