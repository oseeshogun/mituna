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
      QuestionsCompanion.insert(id: 'vvv1', content: 'Qui es-tu ?', type: QuestionType.choice, category: QuestionCategory.history),
      QuestionsCompanion.insert(id: 'vvv2', content: 'Qui suis-je ?', type: QuestionType.choice, category: QuestionCategory.arts),
    ]);
    await answersDao.insertMultipleEntries([
      AnswersCompanion.insert(value: 'Toi', type: AnswerType.text, question: 'vvv1', isCorrect: Value(true)),
      AnswersCompanion.insert(value: 'Lui', type: AnswerType.text, question: 'vvv1'),
      AnswersCompanion.insert(value: 'Dieu', type: AnswerType.text, question: 'vvv1'),
      AnswersCompanion.insert(value: 'Alien', type: AnswerType.text, question: 'vvv1'),
      AnswersCompanion.insert(value: 'Dieu', type: AnswerType.text, question: 'vvv2'),
      AnswersCompanion.insert(value: 'Humain', type: AnswerType.text, question: 'vvv2', isCorrect: Value(true)),
      AnswersCompanion.insert(value: 'Gorille', type: AnswerType.text, question: 'vvv2'),
      AnswersCompanion.insert(value: 'Lion', type: AnswerType.text, question: 'vvv2'),
    ]);
  });

  tearDown(() async {
    await database.close();
  });

  group('Questions with answers', () {
    test('Questions with answers', () async {
      final list = await database.getQuestionsWithAnswers([]);
      expect(list.runtimeType, List<QuestionWithAnswers>, reason: 'getQuestionsWithAnswers must return a list');
      expect(list.length, 0, reason: 'For empty list passed into getQuestionsWithAnswers, we must get an empty list also');
    });
  });
}
