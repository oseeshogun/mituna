import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/presentation/widgets/all.dart';

class QuestionCategoriesHomeList extends HookConsumerWidget {
  final Future<Null> Function([QuestionCategory? category]) startPrint;

  const QuestionCategoriesHomeList({
    super.key,
    required this.startPrint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = 200.0;
    final dragging = useState<bool>(false);
    final dragIndex = useState<Offset>(Offset.zero);
    final dragMap = useState<Map<QuestionCategory, bool>>({});

    return SizedBox(
      height: 190,
      child: ListView.builder(
        itemCount: QuestionCategory.values.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = QuestionCategory.values[index];

          return FadeAnimation(
            delay: 0.5,
            startY: 90.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
              child: CategoryItem(
                category: category,
                onPressed: () => startPrint(category),
              ),
            ),
          );
        },
      ),
    );
  }
}
