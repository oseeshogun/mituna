import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/services/sound_effect.dart';

import 'question_counter_controller.dart';

class QuestionCounter extends StatefulWidget {
  const QuestionCounter({
    super.key,
    required this.count,
    this.onEnd,
    this.onTick,
    required this.controller,
  });

  final int count;
  final void Function(int elapsed)? onEnd;
  final void Function(int time)? onTick;
  final QuestionCounterController controller;

  @override
  State<QuestionCounter> createState() => _QuestionCounterState();
}

class _QuestionCounterState extends State<QuestionCounter>
    with SingleTickerProviderStateMixin {
  int time = 30;
  Timer? _timer;
  final soundEffect = locator.get<SoundEffects>();

  late final AnimationController counterAnimationController;
  late final Animation<double> counterAnimation;
  QuestionCounterState state = QuestionCounterState.running;

  @override
  void initState() {
    super.initState();
    counterAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.count),
    );
    counterAnimationController.addListener(() {
      if (mounted) setState(() {});
    });
    counterAnimation = Tween<double>(begin: 2 * pi, end: 0)
        .animate(counterAnimationController);
    state = widget.controller.state;
    time = widget.count;
    startTimer();
    counterAnimationController.forward();
    soundEffect.play(soundEffect.timeTickingId, 1);
    widget.controller.addListener(() {
      if (mounted) {
        if (widget.controller.state == QuestionCounterState.paused) {
          counterAnimationController.stop();
          soundEffect.stop();
        }
        if (widget.controller.state == QuestionCounterState.stopped) {
          widget.onEnd?.call((widget.count - time).abs());
          soundEffect.stop();
        }
        setState(() {
          state = widget.controller.state;
        });
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == QuestionCounterState.paused ||
          state == QuestionCounterState.stopped) return;
      widget.onTick?.call(time);
      if (mounted) {
        setState(() {
          time--;
        });
      }
      if (time == 0) {
        timer.cancel();
        widget.onEnd?.call((widget.count - time).abs());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    counterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QuestionCounterPainter(counterAnimation.value),
      child: Container(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          time.toString().padLeft(2, '0'),
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

class QuestionCounterPainter extends CustomPainter {
  final double sweepAngle;

  QuestionCounterPainter(this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundCirclePaint = Paint()
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..color = kColorSilver;

    final circlePaint = Paint()
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..color = kColorYellow;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width / 2, backgroundCirclePaint);

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: size.width,
        height: size.width,
      ),
      -pi / 2,
      sweepAngle,
      false,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
