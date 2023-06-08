class CompetitionReward {
  final String uid;
  final int topaz;
  final int duration;

  CompetitionReward({
    required this.uid,
    required this.topaz,
    required this.duration,
  });

  int compareTo(CompetitionReward other) {
    if (topaz == other.topaz && duration == duration) {
      return 0;
    } else if (other.topaz > topaz) {
      return -1;
    } else if (other.topaz == topaz && other.duration > duration) {
      return -1;
    }

    return 1;
  }

  @override
  bool operator ==(Object other) {
    return other is CompetitionReward && other.uid == uid;
  }

  @override
  int get hashCode => Object.hashAll([uid.hashCode, topaz.hashCode, duration.hashCode]);
}
