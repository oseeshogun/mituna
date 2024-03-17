import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'articles_listview.dart';

class BuildLawSection extends HookWidget {
  final bool visible;
  final void Function(bool)? onExpansionChanged;
  final Widget title;
  final List<int> articles;
  final Widget? child;

  const BuildLawSection({
    super.key,
    required this.title,
    required this.visible,
    required this.onExpansionChanged,
    required this.articles,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: visible ? 1.0 : 0.4,
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        onExpansionChanged: onExpansionChanged,
        title: title,
        children: [
          child ?? Container(),
          if (articles.isNotEmpty) ArticlesListView(articles),
        ],
      ),
    );
  }
}
