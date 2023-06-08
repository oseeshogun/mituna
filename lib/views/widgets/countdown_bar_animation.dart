import 'package:flutter/cupertino.dart';
import 'package:mituna/contants/colors.dart';

class CountDownBarAnimation extends StatelessWidget {
  const CountDownBarAnimation({super.key, required this.endTime});

  final int endTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: kColorSilver,
            ),
          ),
          TweenAnimationBuilder(
            duration: Duration(seconds: endTime),
            tween: Tween<double>(begin: 1.0, end: 0.0),
            builder: (context, double widthFactor, Widget? child) {
              return FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: kColorYellow,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
