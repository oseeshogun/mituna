import 'package:mituna/src/utils/uuid_convertor.dart';
import 'package:uuid/uuid.dart';

import '../entities/answer.dart';

class AnswerSerializer {
  static Answer fromJson(Map<String, dynamic> json) {
    return Answer(
      id: UuidConvertor.toInt(const Uuid().v4()),
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
    return data;
  }
}
