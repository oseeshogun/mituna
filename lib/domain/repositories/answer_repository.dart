import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/answer_dto.dart';

abstract class AnswerRepository {
  Future<List<Answer>> getAll();

  Future<int> countAll();

  Future<void> insertAll(List<AnswerDto> entries);
}
