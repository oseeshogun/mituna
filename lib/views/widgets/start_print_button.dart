import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';

import 'oreal_painter.dart';

class StartPrintButton extends StatelessWidget {
  const StartPrintButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OreolPainter(),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kColorYellow,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(.4),
                blurRadius: 10.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.width * .35,
          width: MediaQuery.of(context).size.width * .35,
          child: Lottie.asset(
            'assets/lottiefiles/87455-runing-man.json',
            height: MediaQuery.of(context).size.width * .25,
            width: MediaQuery.of(context).size.width * .25,
          ),
        ),
      ),
    );
  }
}
