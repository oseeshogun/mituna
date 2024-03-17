import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/constants/enums/law_category.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/data/local/daos/laws_dao.dart';
import 'package:mituna/domain/services/notification.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/screens/workcode/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

void useLocalNotificationAppLaunched(BuildContext context) {
  final callback = useCallback(notificationHandler);

  useEffect(() {
    callback(context);
    return null;
  }, []);
}

Future<void> notificationHandler(BuildContext context) async {
  {
    final service = locator.get<FlutterNotification>();
    final prefs = locator.get<SharedPreferences>();
    final dao = locator.get<LawsDao>();

    final details = await service.getAppLaunchedDetails();

    if (details?.didNotificationLaunchApp == true && details?.notificationResponse?.payload == 'workcode') {
      final int articleNumber = prefs.randomWorkCodeArticles ? (await dao.randomArticleNumber(LawCategory.workCode)) : prefs.lastWorkCodeArticleId;
      final article = await dao.getArticleByNumber(articleNumber);

      if (article != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => ArticleScreen(article)),
        );
      }
    }
  }
}
