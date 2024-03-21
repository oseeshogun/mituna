import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sprint_hearts.g.dart';

@riverpod
class SprintHearts extends _$SprintHearts {
  @override
  int build(String id) => 0;

  void update(int value) => (state = value);
}
