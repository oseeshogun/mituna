import 'package:dartz/dartz.dart';
import 'package:mituna/src/http/failures.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/views/arguments/competition_finished.dart';

import 'base_repository.dart';

abstract class ICompetitionRepository extends IBaseRepository {
  Future<Either<FailureEntity, void>> recordCompetitionReward(CompetitionFinishedArguments args);

  Future<Either<FailureEntity, List<CompetitionReward>>> getCompetitionLeaderBoard(String id);
}

class CompetitionRepository extends ICompetitionRepository {
  @override
  Future<Either<FailureEntity, List<CompetitionReward>>> getCompetitionLeaderBoard(String id) {
    return wrapper(() async {
      final data = await client.get('competitions/leaderboard', {'id': id});
      final List<CompetitionReward> rewards =
          (List.from(data).map<Map<String, dynamic>>((record) => Map<String, dynamic>.from(record))).map((record) {
        return CompetitionReward(
          uid: record['uid'],
          topaz: record['topaz'],
          duration: record['duration'],
        );
      }).toList();
      return Right(rewards);
    });
  }

  @override
  Future<Either<FailureEntity, void>> recordCompetitionReward(CompetitionFinishedArguments args) {
    return wrapper(() async {
      final body = <String, dynamic>{'topaz': args.topazWon, 'duration': args.time, 'competitionEpoch': args.competition?.id};
      await client.post('competitions/reward', body);
      return Right(null); 
    });
  }
}
