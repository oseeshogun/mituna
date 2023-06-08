class Ranking {
  final String uid;
  final int score;
  final int position;

  Ranking({
    required this.uid,
    required this.score,
    this.position = 0,
  });

  @override
  String toString() {
    return '[$uid, $score]';
  }

  int compareTo(Ranking other) {
    return score.compareTo(other.score);
  }

  @override
  bool operator ==(Object other) => other is Ranking && other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}
