part of 'all.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({
    super.key,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(
        'opacity',
        Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
      )
      ..tween(
        'translateY',
        Tween(begin: -90.0, end: 0.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );

    return CustomAnimationBuilder(
      delay: Duration(milliseconds: (1000 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, Movie animation, child) => Opacity(
        opacity: animation.get('opacity'),
        child: Transform.translate(
          offset: Offset(
            0,
            animation.get('translateY'),
          ),
          child: child,
        ),
      ),
    );
  }
}
