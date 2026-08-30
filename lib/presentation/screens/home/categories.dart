import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:simple_animations/simple_animations.dart';

class QuestionCategoriesHomeList extends HookConsumerWidget {
  final Future<Null> Function([QuestionCategory? category]) startPrint;

  const QuestionCategoriesHomeList({
    super.key,
    required this.startPrint,
  });

  static const double _tileWidth = 132.0;
  static const Offset _bottomRowOffset = Offset(_tileWidth / 2, -8.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final showHint = useState(true);

    useEffect(() {
      void listener() {
        if (scrollController.offset > 12.0 && showHint.value) {
          showHint.value = false;
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, const []);

    final categories = QuestionCategory.values;
    final pairCount = (categories.length / 2).ceil();

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: ListView.builder(
            controller: scrollController,
            itemCount: pairCount,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 12.0, right: 96.0),
            itemBuilder: (context, index) {
              final topCategory = categories[index * 2];
              final bottomIndex = index * 2 + 1;
              final bottomCategory = bottomIndex < categories.length
                  ? categories[bottomIndex]
                  : null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      delay: 0.5,
                      startY: 90.0,
                      child: _CategoryTile(
                        category: topCategory,
                        onPressed: () => startPrint(topCategory),
                      ),
                    ),
                    if (bottomCategory != null)
                      // Transform.translate keeps the tile's layout slot unchanged,
                      // so the bottom row nests halfway between the top row columns
                      // without overflowing the list.
                      Transform.translate(
                        offset: _bottomRowOffset,
                        child: FadeAnimation(
                          delay: 0.7,
                          startY: 90.0,
                          child: _CategoryTile(
                            category: bottomCategory,
                            onPressed: () => startPrint(bottomCategory),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showHint.value
              ? const _ScrollRightHint()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.onPressed,
  });

  final QuestionCategory category;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: QuestionCategoriesHomeList._tileWidth,
      child: CategoryItem(
        category: category,
        onPressed: onPressed,
      ),
    );
  }
}

class _ScrollRightHint extends StatelessWidget {
  const _ScrollRightHint();

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..scene(
        begin: Duration.zero,
        end: const Duration(milliseconds: 600),
      ).tween('dx', Tween(begin: 0.0, end: 10.0), curve: Curves.easeInOut)
      ..scene(
        begin: const Duration(milliseconds: 600),
        end: const Duration(milliseconds: 1200),
      ).tween('dx', Tween(begin: 10.0, end: 0.0), curve: Curves.easeInOut);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoopAnimationBuilder(
          duration: tween.duration,
          tween: tween,
          builder: (context, Movie value, child) => Transform.translate(
            offset: Offset(value.get<double>('dx'), 0),
            child: child,
          ),
          child:
              const Icon(Icons.arrow_forward, color: Colors.white, size: 28.0),
        ),
        const SizedBox(width: 12.0),
        const Flexible(
          child: TextTitleLevelTwo(
            'Faites défiler vers la droite.',
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
