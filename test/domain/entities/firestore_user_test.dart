import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mituna/domain/entities/firestore_user.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  final datetime = DateTime.now();

  test('From Document', () async {
    await instance.collection('users').doc('uuuuiiidd').set({});
    await instance.collection('users').doc('uuuuiiidd_data').set({
      'displayName': "Elric",
      'diamonds': 10,
      'last_time_win': datetime.millisecondsSinceEpoch,
    });
    final document = await instance.collection('users').doc('uuuuiiidd').get();
    final user = FirestoreUser.fromDocument(document.id, document);

    expect(user.avatar, FirestoreUser.defaultImageUrl);

    final document2 = await instance.collection('users').doc('uuuuiiidd_data').get();
    final user2 = FirestoreUser.fromDocument(document2.id, document2);
    expect(user2.lastWinDate.millisecond, datetime.millisecond);
    expect(user2.displayName, 'Elric');
  });

  test('Default Image url', () {
    expect(FirestoreUser.defaultImageUrl, 'https://res.cloudinary.com/dcmzsqq2y/image/upload/v1673795782/profiles/s_udzknr.png');
  });
}
