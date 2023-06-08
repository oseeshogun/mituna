import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';

final topRankingProvider =
    StateProvider.family<List<Ranking>?, RankingPeriod>((ref, period) => null);

final myRankingProvider =
    StateProvider.family<Ranking?, RankingPeriod>((ref, period) => null);
