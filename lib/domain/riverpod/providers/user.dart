import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituna/domain/entities/firestore_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@riverpod
Stream<User?> firebaseAuthUserStream(FirebaseAuthUserStreamRef ref) {
  return FirebaseAuth.instance.userChanges();
}

@riverpod
Stream<FirestoreUser?> firestoreAuthenticatedUserStream(FirestoreAuthenticatedUserStreamRef ref) {
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
}

@riverpod
Stream<FirestoreUser?> firestoreUserData(FirestoreUserDataRef ref, String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().asyncMap((doc) => FirestoreUser.fromDocument(uid, doc));
}
