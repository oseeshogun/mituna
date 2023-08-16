part of 'all.dart';

class OreolPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  OreolPainter({
    this.color = AppColors.kColorYellow,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width / 2 + 7.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
