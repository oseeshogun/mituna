import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mituna/core/presentation/theme/colors.dart';

class RankFirstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kColorYellow
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
          Colors.white.withAlpha((.6 * 255).toInt()),
          Colors.white.withAlpha((.0 * 255).toInt()),
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
      ..color = AppColors.kColorMarigoldYellow
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
      ..color = AppColors.kColorEarlsGreen
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
