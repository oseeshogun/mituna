import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/data/local/daos/questions_dao.dart';
import 'package:mituna/domain/riverpod/providers/ranking.dart';
import 'package:mituna/domain/usecases/offline_load.dart';
import 'package:mituna/domain/usecases/reward.dart';
import 'package:mituna/domain/usecases/youtube_videos.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/screens/offline_questions_load/offline_questions_load.dart';

void useOfflineSave(BuildContext context) {
  final rewardsUsecase = RewardsUsecase();

  // save records to mongo db
  useEffect(() {
    final authStateListener = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) return;
      userRewardsQueuedProvider(user.uid).addListener(
        locator.get<ProviderContainer>(),
        (previous, next) {
          if (next.value != null && next.value?.isNotEmpty == true) {
            for (final record in next.value!) {
              rewardsUsecase.saveRecord(record).then((value) {
                value.fold((l) {
                  if (l.exception is DioException) {
                    if ((l.exception as DioException).response?.statusCode == 409) {
                      rewardsUsecase.markAsSaved(record);
                    }
                  }
                }, (r) {
                  rewardsUsecase.markAsSaved(record);
                });
              });
            }
          }
        },
        onError: (err, stack) {
          debugPrint(err.toString());
          debugPrint(stack.toString());
        },
        onDependencyMayHaveChanged: () {},
        fireImmediately: true,
      );
    });
    return () {
      authStateListener.cancel();
    };
  }, []);

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
        // background save of questions
        final offlineLoadUsecase = OfflineLoadUsecase();
        final rawQuestions = await offlineLoadUsecase.loadQuestionsFromAsset();
        await offlineLoadUsecase.saveQuestions(rawQuestions);

        // background save of videos
        final youtubeUsecase = YoutubeUsecase();
        final rawVideos = await youtubeUsecase.loadVideosFromAsset();
        await youtubeUsecase.saveVideos(rawVideos);
      } catch (err, st) {
        debugPrint(err.toString());
        debugPrint(st.toString());
      }
    });
    return null;
  }, []);
}
