import 'package:mituna/src/enums/all.dart';

import '../entities/question.dart';

class QuestionJsonSerializer {
  static Question fromJson(Map<String, dynamic> json) {
    final question = Question(
      id: json['id'],
      text: json['text'],
      dbDifficulty: Difficulty.values
          .firstWhere(
            (difficulty) => difficulty.name == json['difficulty'],
            orElse: () => Difficulty.easy,
          )
          .name,
      dbCategory: QuestionCategory.values
          .firstWhere(
            (category) => category.name == json['category'],
            orElse: () => QuestionCategory.history,
          )
          .name,
      dbType: QuestionType.values
          .firstWhere(
            (type) => type.name == json['type'],
            orElse: () => QuestionType.choice,
          )
          .name,
      link: json['link'],
      moreAbout: json['moreAbout'],
    );

    return question;
  }

  static List<Question> fromJsonList(List jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static Map<String, dynamic> toJson(Question question) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = question.id;
    data['text'] = question.text;
    data['difficulty'] = question.difficulty.name;
    data['moreAbout'] = question.moreAbout;
    data['link'] = question.link;
    data['type'] = question.type.name;
    data['category'] = question.category.name;
    return data;
  }
}
