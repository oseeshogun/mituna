part of 'all.dart';

class BlinkingAnimation extends StatelessWidget {
  const BlinkingAnimation({
    super.key,
    required this.builder,
    this.blinking = false,
  });

  final Widget Function(BuildContext context, bool animatedBlinking) builder;
  final bool blinking;

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: const Duration(milliseconds: 200),
      ).tween('blinking', Tween(begin: 0.0, end: 1.0))
      ..scene(
        begin: const Duration(milliseconds: 200),
        end: const Duration(milliseconds: 400),
      ).tween('blinking', Tween(begin: 0.0, end: -1.0));

    return LoopAnimationBuilder(
      duration: tween.duration,
      tween: tween,
      builder: (context, Movie animation, child) => builder(
          context, animation.get<double>('blinking') >= 0.0 && blinking),
    );
  }
}
