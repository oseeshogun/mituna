import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/enums/law_category.dart';
import 'package:mituna/domain/riverpod/providers/laws.dart';
import 'package:mituna/presentation/screens/workcode/article.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

// TODO: Code refactoring
// TODO: search by title, chapters, sections and articles
// TODO: add optional daily remainder for users

class WorkcodeScreen extends HookConsumerWidget {
  const WorkcodeScreen({super.key});

  static const String route = '/workcode';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleExpanded = useState<List<int>>([]);
    final chapterExpanded = useState<Map<int, List<int>>>({});
    final sectionExpanded = useState<Map<int, List<int>>>({});
    final asyncTitles = ref.watch(lawTitleStreamProvider(LawCategory.workCode));

    useEffect(() {
      final keys = chapterExpanded.value.keys;

      for (final key in keys) {
        if (!titleExpanded.value.contains(key)) chapterExpanded.value = {...chapterExpanded.value, key: <int>[]};
      }
      return null;
    }, [titleExpanded.value]);

    useEffect(() {
      final openChapters = chapterExpanded.value.values.expand((element) => element).toList();
      final chapters = sectionExpanded.value.keys;

      for (final key in chapters) {
        if (!openChapters.contains(key)) sectionExpanded.value = {...sectionExpanded.value, key: <int>[]};
      }
      return null;
    }, [chapterExpanded.value, titleExpanded.value]);

    List<Widget> buildArticles(List<int> articles) {
      return articles.map<Widget>((article) {
        return ref.watch(lawArticleStreamProvider(article)).when(
              error: (error, stackTrace) {
                debugPrint(error.toString());
                debugPrint(stackTrace.toString());
                return Container();
              },
              loading: () => CircularProgressIndicator(),
              data: (data) {
                return TextButton(
                  child: AutoSizeText(
                    data == null ? '' : 'Article ${data.number}:  ${data.value}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (data != null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticleScreen(data)));
                    }
                  },
                );
              },
            );
      }).toList();
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        title: TextTitleLevelOne('Code du travail'),
      ),
      body: asyncTitles.when(
        data: (titles) {
          return ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              final title = titles[index];
              return Theme(
                data: ThemeData().copyWith(dividerColor: Colors.white38),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: titleExpanded.value.isEmpty ? 1 : (titleExpanded.value.contains(title.id) ? 1 : 0.4),
                    child: ExpansionTile(
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      onExpansionChanged: (value) {
                        if (value)
                          titleExpanded.value = [...titleExpanded.value, title.id].toSet().toList();
                        else
                          titleExpanded.value = [...titleExpanded.value].where((element) => element != title.id).toList();
                      },
                      title: Text(
                        "Titre ${title.number}: ${title.name}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        ...ref.watch(lawChaptersStreamProvider(title.id)).when(
                              error: (error, stackTrace) {
                                debugPrint(error.toString());
                                debugPrint(stackTrace.toString());
                                return [Container()];
                              },
                              loading: () => [CircularProgressIndicator()],
                              data: (chapters) {
                                return chapters.map<Widget>((chapter) {
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 600),
                                    opacity: (chapterExpanded.value[title.id] ?? []).isEmpty
                                        ? 1
                                        : ((chapterExpanded.value[title.id] ?? []).contains(chapter.id) ? 1 : 0.4),
                                    child: ExpansionTile(
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      title: Text(
                                        "Chapitre ${chapter.number}: ${chapter.name}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onExpansionChanged: (value) {
                                        if (value)
                                          chapterExpanded.value = {
                                            ...chapterExpanded.value,
                                            title.id: [...(chapterExpanded.value[title.id] ?? <int>[]), chapter.id].toSet().toList()
                                          };
                                        else
                                          chapterExpanded.value = {
                                            ...chapterExpanded.value,
                                            title.id: [...(chapterExpanded.value[title.id] ?? <int>[])].where((element) => element != chapter.id).toList()
                                          };
                                      },
                                      children: [
                                        ...ref.watch(lawSectionsStreamProvider(chapter.id)).when(
                                              error: (error, stackTrace) {
                                                debugPrint(error.toString());
                                                debugPrint(stackTrace.toString());
                                                return [Container()];
                                              },
                                              loading: () => [CircularProgressIndicator()],
                                              data: (sections) {
                                                return sections.map<Widget>((section) {
                                                  return AnimatedOpacity(
                                                    duration: const Duration(milliseconds: 600),
                                                    opacity: (sectionExpanded.value[chapter.id] ?? []).isEmpty
                                                        ? 1
                                                        : ((sectionExpanded.value[chapter.id] ?? []).contains(section.id) ? 1 : 0.4),
                                                    child: ExpansionTile(
                                                      iconColor: Colors.white,
                                                      collapsedIconColor: Colors.white,
                                                      title: Text(
                                                        "Section ${section.number}: ${section.name}",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      onExpansionChanged: (value) {
                                                        if (value)
                                                          sectionExpanded.value = {
                                                            ...sectionExpanded.value,
                                                            chapter.id: [...(sectionExpanded.value[chapter.id] ?? <int>[]), section.id].toSet().toList()
                                                          };
                                                        else
                                                          sectionExpanded.value = {
                                                            ...sectionExpanded.value,
                                                            chapter.id: [...(sectionExpanded.value[chapter.id] ?? <int>[])]
                                                                .where((element) => element != section.id)
                                                                .toList()
                                                          };
                                                      },
                                                      children: [
                                                        if (section.articles.isNotEmpty) ...buildArticles(section.articles),
                                                      ],
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                        if (chapter.articles.isNotEmpty) ...buildArticles(chapter.articles),
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                        if (title.articles.isNotEmpty) ...buildArticles(title.articles),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          return Container();
        },
        loading: () => CircularProgressIndicator(),
      ),
    );
  }
}
