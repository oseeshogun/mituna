import 'package:mituna/src/enums/all.dart';
import 'package:objectbox/objectbox.dart';

import 'package:mituna/objectbox.g.dart';
import '../serializers/question.dart';
import 'answer.dart';

@Entity()
class Question {
  @Id()
  int key;

  @Unique()
  String id;

  @Unique()
  String text;

  String dbDifficulty;

  @Transient()
  Difficulty get difficulty => Difficulty.values.firstWhere((element) => element.name == dbDifficulty);

  String? moreAbout;

  String? link;

  String dbType;

  @Transient()
  QuestionType get type => QuestionType.values.firstWhere((element) => element.name == dbType);

  @Transient()
  QuestionCategory get category => QuestionCategory.values.firstWhere((element) => element.name == dbCategory);
  String dbCategory;

  ToMany<Answer> answers = ToMany<Answer>();

  @Transient()
  bool get isByChoice => type == QuestionType.choice;

  @Transient()
  bool get isByTrueOrFalse => type == QuestionType.trueOrFalse;

  Question({
    this.key = 0,
    required this.id,
    required this.text,
    required this.dbDifficulty,
    required this.dbType,
    required this.dbCategory,
    this.link,
    this.moreAbout,
  });

  static Question fromJson(Map<String, dynamic> json) => QuestionJsonSerializer.fromJson(json);

  static List<Question> fromJsonList(List jsonList) => QuestionJsonSerializer.fromJsonList(jsonList);

  Map<String, dynamic> toJson() => QuestionJsonSerializer.toJson(this);
}
