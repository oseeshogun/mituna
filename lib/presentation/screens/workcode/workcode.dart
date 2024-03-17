import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/enums/law_category.dart';
import 'package:mituna/domain/riverpod/providers/laws.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/laws/build_law_section.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

import 'article_search_delegate.dart';

// TODO: add optional daily remainde r for users

class WorkcodeScreen extends HookConsumerWidget {
  const WorkcodeScreen({super.key});

  static const String route = '/workcode';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleExpanded = useState<List<int>>([]);
    final chapterExpanded = useState<Map<int, List<int>>>({});
    final sectionExpanded = useState<Map<int, List<int>>>({});
    final asyncTitles = ref.watch(lawTitleStreamProvider(LawCategory.workCode));
    final asyncArticles = ref.watch(lawArticlesProvider(LawCategory.workCode));
    final asyncChapters = ref.watch(lawChaptersProvider(LawCategory.workCode));
    final asyncSections = ref.watch(lawSectionsProvider(LawCategory.workCode));
    final canSearch = useMemoized(
      () => asyncArticles.value != null && asyncChapters.value != null && asyncSections.value != null && asyncTitles.value != null,
      [asyncArticles, asyncChapters, asyncSections, asyncTitles],
    );

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

    Future<void> search() async {
      await showSearch(
        context: context,
        delegate: ArticleSearchDelegate(
          titles: asyncTitles.value!,
          chapters: asyncChapters.value!,
          sections: asyncSections.value!,
          articles: asyncArticles.value!,
          searchFieldDecorationTheme: InputDecorationTheme(
            fillColor: Colors.transparent,
            filled: true,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        title: TextTitleLevelOne('Code du travail'),
        actions: [
          if (canSearch)
            IconButton(
              onPressed: () => search(),
              icon: const Icon(Icons.search),
            ),
        ],
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
                  child: BuildLawSection(
                    visible: titleExpanded.value.isEmpty || titleExpanded.value.contains(title.id),
                    title: Text(
                      "Titre ${title.number}: ${title.name}",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    articles: title.articles,
                    onExpansionChanged: (value) {
                      if (value)
                        titleExpanded.value = [...titleExpanded.value, title.id].toSet().toList();
                      else
                        titleExpanded.value = [...titleExpanded.value].where((element) => element != title.id).toList();
                    },
                    child: ref.watch(lawChaptersStreamProvider(title.id)).when(
                          error: (error, stackTrace) => Container(),
                          loading: () => CircularProgressIndicator(),
                          data: (chapters) {
                            final expandables = (chapterExpanded.value[title.id] ?? []);
                            return Column(
                              children: chapters
                                  .map<BuildLawSection>(
                                    (chapter) => BuildLawSection(
                                      title: Text(
                                        "Chapitre ${chapter.number}: ${chapter.name}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      visible: expandables.isEmpty || expandables.contains(chapter.id),
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
                                      articles: chapter.articles,
                                      child: ref.watch(lawSectionsStreamProvider(chapter.id)).when(
                                            error: (error, stackTrace) => Container(),
                                            loading: () => CircularProgressIndicator(),
                                            data: (sections) {
                                              final expandables = (sectionExpanded.value[chapter.id] ?? []);
                                              return Column(
                                                children: sections
                                                    .map<BuildLawSection>(
                                                      (section) => BuildLawSection(
                                                        title: Text(
                                                          "Section ${section.number}: ${section.name}",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                        visible: expandables.isEmpty || expandables.contains(section.id),
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
                                                        articles: section.articles,
                                                      ),
                                                    )
                                                    .toList(),
                                              );
                                            },
                                          ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
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
