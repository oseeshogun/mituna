import 'package:mituna/main.dart';
import 'package:mituna/src/db/entities/question.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

import 'question_sprint_info.dart';

class Sprint {
  final int secondsPerQuestion;
  final int initialHearts;
  final int questionCount;
  final Competition? competition;
  final String id = const Uuid().v4();
  final List<String> goodAnswers;

  QuestionCategory? category;

  List<QuestionSprintInfo> questionsInfo = [];
  List<Question> questions = [];
  int _index = 0;
  int _hearts = 3;
  int sprintTime = 0;

  Sprint({
    this.secondsPerQuestion = 15,
    this.initialHearts = 3,
    this.questionCount = 10,
    this.category,
    this.competition,
    this.goodAnswers = const [],
  }) {
    getInitialQuestions();
    _hearts = initialHearts;
    notifyHeartsChanged();
  }

  int get hearts => _hearts;

  bool get isCompetition => competition != null;

  Question get question {
    return questions[_index];
  }

  Future<List<Question>> getQuestionsSource() async {
    if (isCompetition) return competition!.questions;

    final List<Question> actualQuestions = category != null ? questionRepository.getAllForCategory(category!) : await questionRepository.getAll();

    final actualQuestionsMinusGoodAnswer = actualQuestions.where((question) => !goodAnswers.contains(question.id)).toList();

    return actualQuestionsMinusGoodAnswer.length < questionCount ? actualQuestions : actualQuestionsMinusGoodAnswer;
  }

  Future<void> getInitialQuestions() async {
    final questionsSource = await getQuestionsSource();
    assert(questionsSource.isNotEmpty, 'Les questions sont insufficents');
    final question = getRandomElement(questionsSource);
    addQuestion(question);
    addQuestion(await getNextQuestion());
  }

  Future<Question> getNextQuestion() async {
    final questionsSource = await getQuestionsSource();
    final nextQuestion = getRandomElement(questionsSource);
    if (questions.contains(nextQuestion)) {
      return getRandomElement(questionsSource);
    }
    return nextQuestion;
  }

  void incrementTimePassed(int timePassed) {
    sprintTime += secondsPerQuestion - timePassed;
  }

  Future<void> next() async {
    if (finished) return;
    _index++;
    addQuestion(await getNextQuestion());
  }

  void addQuestion(Question question) {
    questions.add(question);
  }

  void failed() {
    _hearts--;
    notifyHeartsChanged();
  }

  bool get finished => _hearts <= 0 || _index + 1 == questionCount;

  bool get finishedWithSuccess => _hearts > 0;

  int get topazWon {
    if (!finishedWithSuccess) return 0;
    int topazs = 0;
    int increment = 1;
    for (int i = 0; i < questionsInfo.length; i++) {
      final questionInfo = questionsInfo[i];
      final QuestionSprintInfo? previousQuestionInfo = i - 1 < 0 ? null : questionsInfo[i - 1];
      if (previousQuestionInfo == null || !previousQuestionInfo.foundCorrect) {
        increment = 1;
      }
      if (questionInfo.foundCorrect) {
        topazs += increment;
        increment++;
      }
    }
    return topazs;
  }

  void notifyHeartsChanged() {
    providerContainer.read(sprintHeartsProvider(id).notifier).state = hearts;
  }

  void timeElapsed(int elapsed, bool foundCorrect) {
    final questionInfo = QuestionSprintInfo(
      question: question,
      elapsed: elapsed,
      foundCorrect: foundCorrect,
    );
    questionsInfo.add(questionInfo);
  }

  int get questionOrder {
    return _index + 1;
  }
}
