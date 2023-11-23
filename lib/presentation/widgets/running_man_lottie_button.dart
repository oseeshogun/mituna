part of 'all.dart';

class RunningManLottieButton extends StatelessWidget {
  const RunningManLottieButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: OreolPainter(),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kColorYellow,
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
        ),
        if (isDecember())
          Transform.translate(
            offset: const Offset(0, 0),
            child: Lottie.asset(
              'assets/lottiefiles/christmas_hat.json',
              width: 200,
              height: 200,
            ),
          ),
      ],
    );
  }
}
