import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/usecase/usecase.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/entities/sprint.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/locator.dart';
import 'package:uuid/uuid.dart';

class SprintUsecase extends Usecase {
  final db = locator.get<AppDatabase>();
  final questionsDao = locator.get<QuestionsDao>();

  Future<Sprint> start({QuestionCategory? category}) async {
    final generatedId = const Uuid().v4();
    final questionsIdList = await questionsDao.randomQuestionIdList();
    final questions = await db.getQuestionsWithAnswers(questionsIdList);
    return Sprint(id: generatedId, questions: questions);
  }

  Future<void> saveTopazForAuthenticatedUser(int topaz) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final container = locator.get<ProviderContainer>();
    final firestoreUser = await container.read(firestoreAuthenticatedUserStreamProvider.future);
    FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'diamonds': (firestoreUser?.diamonds ?? 0) + topaz,
        'last_time_win': DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );
  }
}
