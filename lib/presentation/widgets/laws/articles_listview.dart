import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/domain/riverpod/providers/laws.dart';
import 'package:mituna/presentation/screens/workcode/article.dart';

class ArticlesListView extends HookConsumerWidget {
  final List<int> articles;

  const ArticlesListView(this.articles, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ...articles.map<Widget>((id) {
          return switch (ref.watch(lawArticleStreamProvider(id))) {
            AsyncData(:final value) => TextButton(
                child: AutoSizeText(
                  value == null ? '' : 'Article ${value.number}:  ${value.value}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (value != null) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticleScreen(value)));
                  }
                },
              ),
            AsyncLoading() => CircularProgressIndicator(),
            _ => Container(),
          };
        }).toList(),
      ],
    );
  }
}
