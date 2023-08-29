import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';

void main() {
  late AppDatabase database;
  late QuestionsDao questionsDao;
  late AnswersDao answersDao;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    questionsDao = QuestionsDao(database);
    answersDao = AnswersDao(database);

    await questionsDao.insertMultipleEntries([
      QuestionCompanion.insert(id: 'vvv1', content: 'Qui es-tu ?', type: QuestionType.choice, category: QuestionCategory.history),
      QuestionCompanion.insert(id: 'vvv2', content: 'Qui suis-je ?', type: QuestionType.choice, category: QuestionCategory.arts),
    ]);
    await answersDao.insertMultipleEntries([
      AnswerCompanion.insert(value: 'Toi', type: AnswerType.text, question: 'vvv1', isCorrect: Value(true)),
      AnswerCompanion.insert(value: 'Lui', type: AnswerType.text, question: 'vvv1'),
      AnswerCompanion.insert(value: 'Dieu', type: AnswerType.text, question: 'vvv1'),
      AnswerCompanion.insert(value: 'Alien', type: AnswerType.text, question: 'vvv1'),
      AnswerCompanion.insert(value: 'Dieu', type: AnswerType.text, question: 'vvv2'),
      AnswerCompanion.insert(value: 'Humain', type: AnswerType.text, question: 'vvv2', isCorrect: Value(true)),
      AnswerCompanion.insert(value: 'Gorille', type: AnswerType.text, question: 'vvv2'),
      AnswerCompanion.insert(value: 'Lion', type: AnswerType.text, question: 'vvv2'),
    ]);
  });

  tearDown(() async {
    await database.close();
  });

  group('Answer Insertion', () {
    test('Invalid Answer insertion', () async {
      try {
        await answersDao.insertMultipleEntries([AnswerCompanion.insert(value: 'Lion', type: AnswerType.text, question: 'vvv3')]);
        throw Exception('Must not come to this line.');
      } catch (error) {
        expect(error.runtimeType, SqliteException);
      }
    });

    test('Answers Length', () async {
      final count = await answersDao.count();
      expect(count, 8);
    });

    test('Answers get all', () async {
      final list = await answersDao.getAll;
      expect(list.runtimeType, List<AnswerData>);
    });
  });
}
