class SprintFinishedException implements Exception {
  final String message;
  SprintFinishedException(this.message);

  @override
  String toString() {
    return 'SprintFinishedException($message)';
  }
}
