import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/domain/entities/firestore_user.dart';

final firebaseAuthUserStreamProvider = StreamProvider((ref) => FirebaseAuth.instance.userChanges());

final firestoreAuthenticatedUserStreamProvider = StreamProvider<FirestoreUser?>((ref) {
  return ref.watch(firebaseAuthUserStreamProvider).when(
        data: (firebaseUser) {
          if (firebaseUser == null) return Stream.value(null);
          return FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).snapshots().asyncMap((doc) {
            return FirestoreUser.fromDocument(
              firebaseUser.uid,
              doc,
            );
          });
        },
        error: (error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          return Stream.value(null);
        },
        loading: () => Stream.value(null),
      );
});

final firestoreUserDataProvider = StreamProvider.family<FirestoreUser?, String>((ref, uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().asyncMap((doc) => FirestoreUser.fromDocument(uid, doc));
});
