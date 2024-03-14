import 'package:mituna/core/constants/enums/law_category.dart';
import 'package:mituna/data/local/daos/laws_dao.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'laws.g.dart';

@Riverpod(keepAlive: true)
Stream<List<LawTitle>> lawTitleStream(LawTitleStreamRef ref, LawCategory category) {
  final dao = locator.get<LawsDao>();
  return dao.streamAllTitles(category);
}

@Riverpod(keepAlive: true)
Stream<List<LawChapter>> lawChaptersStream(LawChaptersStreamRef ref, int titleId) {
  final dao = locator.get<LawsDao>();
  return dao.streamChapters(titleId);
}

@Riverpod(keepAlive: true)
Stream<List<LawSection>> lawSectionsStream(LawSectionsStreamRef ref, int chapterId) {
  final dao = locator.get<LawsDao>();
  return dao.streamSections(chapterId);
}

@Riverpod(keepAlive: true)
Stream<LawArticle?> lawArticleStream(LawArticleStreamRef, int number) {
  final dao = locator.get<LawsDao>();
  return dao.streamSingleArticle(number);
}
