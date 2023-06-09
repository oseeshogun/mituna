import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/http/repositories/base_repository.dart';
import 'package:mituna/src/models/all.dart';

import '../failures.dart';

abstract class IRewardsRepository extends IBaseRepository {
  Future<Either<FailureEntity, void>> registerRanking(int topaz);

  Future<Either<FailureEntity, List<Ranking>>> getTopRanking(RankingPeriod period);

  Future<Either<FailureEntity, Ranking>> getMyRanking(RankingPeriod period);

  Future<Either<FailureEntity, void>> recordReward(RewardRecord reward);

  Future<Either<FailureEntity, void>> deleteRewards(String uid);
}

class RewardsRepository extends IRewardsRepository {
  @override
  Future<Either<FailureEntity, void>> deleteRewards(String uid) {
    return wrapper<void>(() async {
      await client.delete('rewards');
      return Right(null);
    });
  }

  @override
  Future<Either<FailureEntity, Ranking>> getMyRanking(RankingPeriod period) {
    return wrapper<Ranking>(() async {
      final data = await client.get('rewards/mine', {'period': period.name});
      final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
      final ranking = Ranking(uid: uid, score: data['score'], position: data['ranked']);
      return Right(ranking);
    });
  }

  @override
  Future<Either<FailureEntity, List<Ranking>>> getTopRanking(RankingPeriod period) {
    return wrapper<List<Ranking>>(() async {
      final data = await client.get('rewards/top', {'period': period.name});
      final rankings = (data as List).map<Ranking>((rank) => Ranking(uid: rank['_id'], score: rank['count'])).toList();
      return Right(rankings);
    });
  }

  @override
  Future<Either<FailureEntity, void>> recordReward(RewardRecord reward) {
    return wrapper<void>(() async {
      final data = <String, dynamic>{'topaz': reward.score, 'date': reward.createdAt.millisecondsSinceEpoch};
      await client.post('rewards/create', data);
      return Right(null);
    });
  }

  @override
  Future<Either<FailureEntity, void>> registerRanking(int topaz) {
    return wrapper<void>(() async {
      await client.post('rewards/save', {'topaz': topaz});
      return Right(null);
    });
  }
}
