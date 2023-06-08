import 'package:flutter/cupertino.dart';

class WinnerText extends StatelessWidget {
  final String text;
  final int topazWon;
  const WinnerText({super.key, required this.text, required this.topazWon});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: text, children: [TextSpan(text: topazWon.toString())]));
  }
}
