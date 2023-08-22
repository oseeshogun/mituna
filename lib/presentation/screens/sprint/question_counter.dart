import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/domain/services/sound_effect.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/utils/painters/all.dart';

class QuestionCounter extends HookWidget {
  QuestionCounter({
    super.key,
    required this.count,
    required this.state,
    this.onEnd,
    this.onTick,
  });

  final soundEffect = locator.get<SoundEffects>();
  final int count;
  final void Function()? onEnd;
  final void Function(int time)? onTick;
  final ValueNotifier<QuestionCounterState> state;

  @override
  Widget build(BuildContext context) {
    final counterAnimationController = useAnimationController(duration: Duration(seconds: count));
    final counterAnimation = useAnimation(Tween<double>(begin: 2 * pi, end: 0).animate(counterAnimationController));
    final isMounted = useIsMounted();
    final time = useState(count);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.value == QuestionCounterState.paused || state.value == QuestionCounterState.stopped) {
          counterAnimationController.stop();
          soundEffect.stop();
          return;
        }
        onTick?.call(time.value);
        if (isMounted()) time.value = max(0, time.value - 1);
        if (time.value == 0) {
          timer.cancel();
          counterAnimationController.stop();
          soundEffect.stop();
          onEnd?.call();
        }
      });
      return () => timer.cancel();
    }, []);

    useEffect(() {
      counterAnimationController.forward();
      soundEffect.play(soundEffect.timeTickingId, 1);
      return null;
    }, []);

    return CustomPaint(
      painter: QuestionCounterPainter(counterAnimation),
      child: Container(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          time.value.toString().padLeft(2, '0'),
          style: const TextStyle(
            fontSize: 42.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
