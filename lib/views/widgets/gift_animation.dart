import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class GiftAnimation extends StatelessWidget {
  final Widget child;

  const GiftAnimation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: const Duration(milliseconds: 600),
      ).tween('angle', Tween(begin: 0.0, end: 1.8))
      ..scene(
        begin: const Duration(milliseconds: 700),
        end: const Duration(milliseconds: 1300),
      ).tween('angle', Tween(begin: 1.8, end: -1.8))
      ..scene(
        begin: const Duration(milliseconds: 1400),
        end: const Duration(milliseconds: 2000),
      ).tween('angle', Tween(begin: -1.8, end: 0))
      ..scene(
        begin: const Duration(milliseconds: 2000),
        end: const Duration(milliseconds: 4000),
      ).tween('angle', Tween(begin: 0.0, end: 0));

    return LoopAnimationBuilder(
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, Movie animation, child) => Transform.rotate(
        angle: animation.get('angle'),
        child: child,
      ),
    );
  }
}
