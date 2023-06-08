import 'package:flutter/material.dart';
import 'package:mituna/contants/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.child,
    required this.onPressed,
    this.backgroundColor = kColorYellow,
    this.foregroundColor = kColorBlack,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0),
    Key? key,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          foregroundColor: MaterialStateProperty.all(foregroundColor),
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
