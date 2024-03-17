import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/domain/riverpod/providers/laws.dart';
import 'package:mituna/main.dart';
import 'package:mituna/presentation/screens/workcode/article.dart';
import 'package:mituna/presentation/widgets/laws/build_law_section.dart';

class ArticleSearchDelegate extends SearchDelegate<String> {
  final List<LawArticle> articles;
  final List<LawSection> sections;
  final List<LawChapter> chapters;
  final List<LawTitle> titles;

  final Fuzzy<String> fuse;

  ArticleSearchDelegate({
    required this.articles,
    required this.sections,
    required this.chapters,
    required this.titles,
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
  }) : this.fuse = Fuzzy<String>(
          [
            ...articles.map((e) => e.value).toList(),
            ...sections.map((e) => e.name).toList(),
            ...chapters.map((e) => e.name).toList(),
            ...titles.map((e) => e.name).toList(),
          ],
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        titleLarge: theme.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
        fillColor: Colors.grey[200],
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey, width: 0),
        ),
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        titleSpacing: 0,
        backgroundColor: AppColors.kColorBlueRibbon,
        iconTheme: theme.iconTheme.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => (query = ''),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return build();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return build();
  }

  Widget build() {
    final result = fuse.search(query, 30);

    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.white38),
      child: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          final value = result[index];
          final article = articles.firstWhereOrNull((element) => element.value == value.item);
          final section = sections.firstWhereOrNull((element) => element.name == value.item);
          final chapter = chapters.firstWhereOrNull((element) => element.name == value.item);
          final title = titles.firstWhereOrNull((element) => element.name == value.item);

          if (title != null)
            return buildTitle(title);
          else if (chapter != null)
            return buildChapter(chapter);
          else if (section != null)
            return buildSection(section);
          else if (article == null) return Container();

          return TextButton(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'Article ${article.number}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  article.value,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                const Divider(color: Colors.white38),
              ],
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArticleScreen(article),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTitle(LawTitle title) {
    return BuildLawSection(
      title: Text(
        "Titre ${title.number}: ${title.name}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      visible: true,
      onExpansionChanged: (_) {},
      articles: title.articles,
      child: switch (providerContainer.read(lawChaptersStreamProvider(title.id))) {
        AsyncLoading() => Container(),
        AsyncData(:final value) => Column(
            children: value
                .map(
                  (chapter) => buildChapter(chapter),
                )
                .toList(),
          ),
        _ => Container(),
      },
    );
  }

  Widget buildChapter(LawChapter chapter) {
    return BuildLawSection(
      title: Text(
        "Chapitre ${chapter.number}: ${chapter.name}",
        style: TextStyle(color: Colors.white),
      ),
      visible: true,
      onExpansionChanged: (_) {},
      articles: chapter.articles,
      child: switch (providerContainer.read(lawSectionsStreamProvider(chapter.id))) {
        AsyncLoading() => Container(),
        AsyncData(:final value) => Column(
            children: value
                .map(
                  (section) => buildSection(section),
                )
                .toList(),
          ),
        _ => Container(),
      },
    );
  }

  Widget buildSection(LawSection section) {
    return BuildLawSection(
      title: Text(
        "Section ${section.number}: ${section.name}",
        style: TextStyle(color: Colors.white),
      ),
      visible: true,
      onExpansionChanged: (_) {},
      articles: section.articles,
    );
  }
}
