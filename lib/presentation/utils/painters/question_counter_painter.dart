part of 'all.dart';

class QuestionCounterPainter extends CustomPainter {
  final double sweepAngle;

  QuestionCounterPainter(this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundCirclePaint = Paint()
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..color = AppColors.kColorSilver;

    final circlePaint = Paint()
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..color = AppColors.kColorYellow;

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
