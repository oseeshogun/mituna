part of '../all.dart';

class UserHearts extends StatelessWidget {
  final int remainingHearts;

  const UserHearts({
    super.key,
    required this.remainingHearts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: AppSizes.kScaffoldHorizontalPadding,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.kColorSilver, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeartAnimatedIcon(remainingHearts),
          const SizedBox(width: 20.0),
          TextTitleLevelTwo(remainingHearts.toString()),
        ],
      ),
    );
  }
}

class HeartAnimatedIcon extends HookWidget {
  const HeartAnimatedIcon(this.remainingHearts, {super.key});

  final int remainingHearts;

  @override
  Widget build(BuildContext context) {
    const double size = 30.0;
    const bubblesSize = size * 2.0;
    const circleSize = size * 0.8;
    const Duration animationDuration = Duration(milliseconds: 1000);
    final controller = useAnimationController(duration: animationDuration);
    final outerCircleAnimation = useAnimation(Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    ));
    final innerCircleAnimation = useAnimation(Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    ));
    final scaleAnimation = useAnimation(Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    ));
    final bubblesAnimation = useAnimation(Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    ));

    const BubblesColor bubblesColor = BubblesColor(
      dotPrimaryColor: Color(0xFFFFC107),
      dotSecondaryColor: Color(0xFFFF9800),
      dotThirdColor: Color(0xFFFF5722),
      dotLastColor: Color(0xFFF44336),
    );

    const circleColor = CircleColor(
      start: Color(0xFFFF5722),
      end: Color(0xFFFFC107),
    );

    useEffect(() {
      controller.reset();
      controller.forward();
      return null;
    }, [remainingHearts]);

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext c, Widget? w) {
        const Widget likeWidget = Icon(
          CupertinoIcons.heart_fill,
          color: AppColors.kColorOrange,
        );
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              top: (size - bubblesSize) / 2.0,
              left: (size - bubblesSize) / 2.0,
              child: CustomPaint(
                size: const Size(bubblesSize, bubblesSize),
                painter: BubblesPainter(
                  currentProgress: bubblesAnimation,
                  color1: bubblesColor.dotPrimaryColor,
                  color2: bubblesColor.dotSecondaryColor,
                  color3: bubblesColor.dotThirdColorReal,
                  color4: bubblesColor.dotLastColorReal,
                ),
              ),
            ),
            Positioned(
              top: (size - circleSize) / 2.0,
              left: (size - circleSize) / 2.0,
              child: CustomPaint(
                size: const Size(circleSize, circleSize),
                painter: CirclePainter(
                  innerCircleRadiusProgress: innerCircleAnimation,
                  outerCircleRadiusProgress: outerCircleAnimation,
                  circleColor: circleColor,
                ),
              ),
            ),
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: controller.isAnimating ? scaleAnimation : 1.0,
                child: const SizedBox(
                  height: size,
                  width: size,
                  child: likeWidget,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BubblesColor {
  const BubblesColor({
    required this.dotPrimaryColor,
    required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });
  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color? dotThirdColor;
  final Color? dotLastColor;
  Color get dotThirdColorReal => dotThirdColor ?? dotPrimaryColor;

  Color get dotLastColorReal => dotLastColor ?? dotSecondaryColor;
}

class OvershootCurve extends Curve {
  const OvershootCurve([this.period = 2.5]);

  final double period;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType($period)';
  }
}
