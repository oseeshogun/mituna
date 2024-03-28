import 'package:equatable/equatable.dart';
import 'package:mituna/core/constants/enums/all.dart';

class QuestionDto extends Equatable {
  final String id;
  final String content;
  final QuestionType type;
  final QuestionCategory category;

  QuestionDto({
    required this.id,
    required this.content,
    required this.type,
    required this.category,
  });

  @override
  List<String> get props => [id];
}
