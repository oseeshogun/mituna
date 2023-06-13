import '../entities/answer.dart';

class AnswerSerializer {
  static Answer fromJson(Map<String, dynamic> json) {
    if (json['question'] == null) {
      print(json);
    }
    return Answer(
      question: json['question'],
      value: json['response'] is bool ? (json['response'] ? 'Vrai' : 'Faux') : json['response'],
      isCorrect: json['isCorrect'],
      dbType: AnswerType.values
          .firstWhere(
            (element) => element.name == json['type'],
            orElse: () => AnswerType.text,
          )
          .name,
    );
  }

  static List<Answer> fromJsonList(List jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static Map<String, dynamic> toJson(Answer answer) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = answer.id;
    data['response'] = answer.value;
    data['isCorrect'] = answer.isCorrect;
    data['type'] = answer.dbType;
    data['question'] = answer.question;
    return data;
  }
}
