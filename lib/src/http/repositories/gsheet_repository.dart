import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/src/http/failures.dart';

import 'base_repository.dart';

abstract class IGsheetRepository extends IBaseRepository {
  Future<Either<FailureEntity, void>> sendFeedBack(String uid, String object, String message);

  Future<Either<FailureEntity, void>> setUserWinner(String phone);

  Future<Either<FailureEntity, void>> sendQuestionContribution(String uid, String answer, String question);
}

class GheetRepository extends IGsheetRepository {
  @override
  Future<Either<FailureEntity, void>> sendFeedBack(String uid, String object, String message) {
    return wrapper(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      final useName = currentUser?.displayName != null && currentUser?.displayName?.isNotEmpty == true;
      final data = <String, dynamic>{'name': useName ? currentUser?.displayName : 'No name', 'object': object, 'message': message};
      await client.post('gsheets/feedback', data);
      return Right(null);
    });
  }

  @override
  Future<Either<FailureEntity, void>> sendQuestionContribution(String uid, String answer, String question) {
    return wrapper(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      final useName = currentUser?.displayName != null && currentUser?.displayName?.isNotEmpty == true;
      final data = <String, dynamic>{'name': useName ? currentUser?.displayName : 'No name', 'question': question, 'answer': answer};
      await client.post('gsheets/contribution', data);
      return Right(null);
    });
  }

  @override
  Future<Either<FailureEntity, void>> setUserWinner(String phone) {
    return wrapper(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      final useName = currentUser?.displayName != null && currentUser?.displayName?.isNotEmpty == true;
      final data = <String, dynamic>{'name': useName ? currentUser?.displayName : 'No name', 'phone': phone};
      await client.post('gsheets/claim_price', data);
      return Right(null);
    });
  }
}
