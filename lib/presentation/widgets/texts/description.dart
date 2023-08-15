part of 'all.dart';

class TextDescription extends StatelessWidget {
  const TextDescription(
    this.text, {
    this.color = Colors.white,
    this.opacity = 0.8,
    this.textAlign = TextAlign.left,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color color;
  final double opacity;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: TextStyle(
        color: color.withOpacity(opacity),
        fontSize: 18,
      ),
      textAlign: textAlign,
    );
  }
}
