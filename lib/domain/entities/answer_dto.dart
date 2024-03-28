import 'package:equatable/equatable.dart';
import 'package:mituna/core/constants/enums/all.dart';

class AnswerDto extends Equatable {
  final String value;
  final bool isCorrect;
  final AnswerType type;
  final String question;

  AnswerDto({
    required this.value,
    required this.isCorrect,
    required this.type,
    required this.question,
  });

  @override
  List<String> get props => [value, question];
}
