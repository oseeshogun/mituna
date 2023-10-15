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

  test('Get all must be a list', () async {
    final list = await questionsDao.getAll;
    expect(list.runtimeType, List<QuestionData>);
  });

  test('Get questions count', () async {
    final count = await questionsDao.count();
    expect(count, 2);
  });

  group('Random Questions', () {
    test('Random question id list', () async {
      final list = await questionsDao.randomQuestionIdList();

      expect(list.runtimeType, List<String>);
    });

    test('Random question by category', () async {
      final list = await questionsDao.randomQuestionIdList(categories: [QuestionCategory.history.name]);

      expect(list.length, 1);

      final question = await questionsDao.getById(list.first);

      expect(question?.category, QuestionCategory.history);
    });
  });

  test('Unique question id', () async {
    try {
      await questionsDao.create(QuestionCompanion.insert(id: 'vvv2', content: 'What ever', type: QuestionType.choice, category: QuestionCategory.arts));
    } catch (error) {
      expect(error.runtimeType, SqliteException);
    }
  });

  test('Create question', () async {
    final question =
        await questionsDao.create(QuestionCompanion.insert(id: 'vvv4', content: 'What ever', type: QuestionType.choice, category: QuestionCategory.arts));
    expect(question.runtimeType, QuestionData);
  });
}
