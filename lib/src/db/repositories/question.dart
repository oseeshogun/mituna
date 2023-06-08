import 'package:mituna/objectbox.g.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


import '../entities/question.dart';

class QuestionRepository {
  late final Store _store;

  late final Box<Question> _questionBox;

  QuestionRepository._create(this._store) {
    _questionBox = Box<Question>(_store);
  }

  static Future<QuestionRepository> create() async {
    final store = await openStore(directory: path.join((await getApplicationDocumentsDirectory()).path, "obx-mituna"));
    return QuestionRepository._create(store);
  }

  Stream<List<Question>> watchAll() {
    final builder = _questionBox.query();
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  List<Question> getAll() => _questionBox.getAll();

  List<Question> getAllForCategory(QuestionCategory category) {
    return _questionBox.query(Question_.dbCategory.equals(category.name)).build().find();
  }
}
