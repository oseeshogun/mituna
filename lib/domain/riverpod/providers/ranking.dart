import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/domain/entities/ranking.dart';

final rankingsProvider = StateProvider.family<List<Ranking>, String>((ref, period) => []);