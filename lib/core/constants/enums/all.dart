import 'package:mituna/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'question_category.dart';

enum QuestionType { choice, trueOrFalse }

enum AnswerType { boolean, text }

enum QuestionCounterState { running, paused, stopped }

enum RankingPeriod { all, month, week }

enum RewardRecordState { queue, recorded }
