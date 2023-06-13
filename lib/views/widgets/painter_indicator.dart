import 'package:flutter/material.dart';
import 'package:mituna/contants/colors.dart';

class PainterIndicator extends CustomPainter {
  final bool active;

  PainterIndicator({this.active = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kColorYellow
      ..style = PaintingStyle.fill;

    if (!active) return;

    canvas.drawCircle(Offset(size.width, 0), 5.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
