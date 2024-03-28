import 'package:drift/drift.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/answer_dto.dart';
import 'package:mituna/domain/repositories/answer_repository.dart';
import 'package:mituna/locator.dart';

class AnswerRepositoryImpl extends AnswerRepository {
  final dao = locator<AnswersDao>();

  @override
  Future<int> countAll() async => (await dao.count()) ?? 0;

  @override
  Future<List<Answer>> getAll() => dao.getAll;

  @override
  Future<void> insertAll(List<AnswerDto> answers) async {
    final entries = answers
        .map(
          (e) => AnswersCompanion.insert(
            value: e.value,
            isCorrect: Value(e.isCorrect),
            type: e.type,
            question: e.question,
          ),
        )
        .toList();
    await dao.insertMultipleEntries(entries);
  }
}
