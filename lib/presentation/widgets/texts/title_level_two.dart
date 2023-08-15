part of 'all.dart';

class TextTitleLevelTwo extends StatelessWidget {
  const TextTitleLevelTwo(
    this.text, {
    this.color = Colors.white,
    this.textAlign = TextAlign.center,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}
