import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mituna/contants/colors.dart';

class RankFirstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kColorYellow
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(8.0, -15.0);
    path.lineTo(size.width - 8.0, -15.0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    final exceptionPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(0, -120.0),
        [
          Colors.white.withOpacity(.6),
          Colors.white.withOpacity(.0),
        ],
      );

    final exceptionPath = Path();
    exceptionPath.moveTo(5.0, 0);
    exceptionPath.lineTo(-20.0, -120.0);
    exceptionPath.lineTo(size.width + 20.0, -120.0);
    exceptionPath.lineTo(size.width - 5.0, 0);
    exceptionPath.close();

    canvas.drawPath(exceptionPath, exceptionPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RankSecondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kColorMarigoldYellow
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(16.0, -15.0);
    path.lineTo(size.width + 16.0, -15.0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RankThirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kColorEarlsGreen
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, -15.0);
    path.lineTo(size.width - 16.0, -15.0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
