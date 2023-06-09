import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mituna/src/http/client.dart';

import '../exceptions.dart';
import '../failures.dart';

abstract class IBaseRepository {
  final client = ApiClient(dotenv.env['API_URL']!);

  Future<Either<FailureEntity, T>> wrapper<T>(Future<Either<FailureEntity, T>> Function() callback) async {
    try {
      return await callback();
    } on ServerException {
      return const Left(ServerFailure());
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on DataParsingException {
      return const Left(DataParsingFailure());
    } on NoConnectionException {
      return const Left(NoConnectionFailure());
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

}
