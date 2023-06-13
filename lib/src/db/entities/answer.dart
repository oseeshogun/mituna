import 'package:mituna/src/db/serializers/answer.dart';
import 'package:objectbox/objectbox.dart';

import 'package:mituna/objectbox.g.dart';

enum AnswerType { boolean, text }

@Entity()
class Answer {
  @Id()
  int id;

  String question;

  bool isCorrect;

  String dbType;

  @Transient()
  AnswerType get type => AnswerType.values.firstWhere((element) => element.name == dbType, orElse: () => AnswerType.text);

  String value;

  Answer({
    this.id = 0,
    required this.value,
    required this.question,
    required this.dbType,
    this.isCorrect = false,
  });
  
  Map<String, dynamic> toJson() => AnswerSerializer.toJson(this);

  static Answer fromJson(Map<String, dynamic> json) => AnswerSerializer.fromJson(json);

  static List<Answer> fromJsonList(List jsonList) => AnswerSerializer.fromJsonList(jsonList);

  @override
  String toString() {
    return 'Answer{id: $id, question: $question, isCorrect: $isCorrect, dbType: $dbType, value: $value}';
  }
}
