import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/data/local/daos/answers_dao.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:uuid/uuid.dart';

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

  test('Basic Sprint', () async {
    final generatedId = const Uuid().v4();
    final list = await questionsDao.randomQuestionIdList();
    final sprint = Sprint(
      id: generatedId,
      questions: await database.getQuestionsWithAnswers(list),
      category: null,
      answered: [],
    );
    expect(sprint.answered.length, 0);
    expect(sprint.questionCount, list.length);
    expect(sprint.finished, false);
    expect(sprint.category, null);
    expect(sprint.hearts, 3);
    expect(sprint.id, generatedId);

    final question = sprint.randomQuestion;

    expect(question.runtimeType, QuestionWithAnswers);

    sprint.answer(question!, question.answers.firstWhere((element) => element.isCorrect), 18);

    expect(sprint.hearts, 3);
    expect(sprint.questionIndexPlusOne, 2);
    expect(sprint.remainingQuestionCount, 1);
  });
}
