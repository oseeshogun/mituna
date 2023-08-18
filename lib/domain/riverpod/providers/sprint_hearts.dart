import 'package:hooks_riverpod/hooks_riverpod.dart';

final sprintHeartsProvider = StateProvider.family<int, String>((ref, id) => 0);