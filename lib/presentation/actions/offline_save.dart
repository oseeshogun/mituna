import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/domain/usecases/offline_load.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/screens/offline_questions_load/offline_questions_load.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void useOfflineSave(BuildContext context) {

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final QuestionsDao questionsDao = locator.get<QuestionsDao>();
      if (await questionsDao.isEmpty()) {
        Navigator.of(context).pushNamed(OfflineQuestionsLoadScreen.route);
      }
    });
    return null;
  }, []);

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        final prefs = locator.get<SharedPreferences>();
        final info = await PackageInfo.fromPlatform();
        final version = info.version;
        if (prefs.offlineSaved(version) == true) return;
        // background save of questions
        final offlineLoadUsecase = OfflineLoadUsecase();

        // background save of questions
        await offlineLoadUsecase.saveQuestions();

        prefs.offlineSavedDone(version);
      } catch (err, st) {
        debugPrint(err.toString());
        debugPrint(st.toString());
      }
    });
    return null;
  }, []);
}
