part of 'all.dart';

class TextTitleLevelOne extends StatelessWidget {
  const TextTitleLevelOne(
    this.text, {
    this.color = Colors.white,
    this.textAlign = TextAlign.center,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
