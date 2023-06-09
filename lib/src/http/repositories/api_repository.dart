import 'package:dartz/dartz.dart';
import 'package:mituna/src/http/repositories/base_repository.dart';

import '../failures.dart';

abstract class IApiRepository extends IBaseRepository {
  Future<Either<FailureEntity, int>> getNextCompetitionTime();
}

class ApiRepository extends IApiRepository {

  @override
  Future<Either<FailureEntity, int>> getNextCompetitionTime() {
    return wrapper<int>(() async {
      final response = await client.get('time');
      return response['time'];
    });
  }
}
