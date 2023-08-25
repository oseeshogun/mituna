import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/domain/usecase/usecase.dart';
import 'package:mituna/domain/services/gsheet.dart';

class GsheetUsecase extends Usecase {
  final _gsheetService = GsheetService();
  final _auth = FirebaseAuth.instance;

  Future<Either<Failure, bool?>> addFeedback({required String? uid, required String? name, required String subject, required String message}) {
    return wrapper(() async {
      final worksheet = await _gsheetService.worksheet;
      return await worksheet?.values.appendRow([_auth.currentUser?.uid, name, subject, message, DateTime.now().toIso8601String()]);
    });
  }
}
