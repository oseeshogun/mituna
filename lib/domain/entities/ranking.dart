class Ranking {
  final int ranking;
  final String uid;
  final int topaz;

  Ranking({
    required this.ranking,
    required this.uid,
    required this.topaz,
  });

  @override
  bool operator ==(Object other) {
    return other is Ranking && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
