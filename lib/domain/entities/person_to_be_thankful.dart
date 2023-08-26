class PersonToBeThankful {
  final String name;
  final String? portfolio;
  final String linkedin;
  final String? whatsapp;

  const PersonToBeThankful({
    required this.name,
    required this.linkedin,
    this.portfolio,
    this.whatsapp,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is PersonToBeThankful && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
