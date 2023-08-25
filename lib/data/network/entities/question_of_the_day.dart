import 'package:json_annotation/json_annotation.dart';

part 'question_of_the_day.g.dart';

@JsonSerializable()
class QuestionOfTheDayData {
  @JsonKey(name: '_id')
  final String id;
  final String question;
  final String date;
  final String reponse;
  final List<String> assertions;

  QuestionOfTheDayData({
    required this.id,
    required this.question,
    required this.assertions,
    required this.date,
    required this.reponse,
  });

  factory QuestionOfTheDayData.fromJson(Map<String, dynamic> json) => _$QuestionOfTheDayDataFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionOfTheDayDataToJson(this);
}
