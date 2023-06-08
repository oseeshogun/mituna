import 'package:flutter/cupertino.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';

import '../text/title_level_two.dart';
import 'bubbles_painter.dart';
import 'circle_painter.dart';
import 'controller.dart';

class UserHearts extends StatelessWidget {
  final int remainingHearts;
  final UserHeartsController? controller;

  const UserHearts({
    super.key,
    required this.remainingHearts,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: kScaffoldHorizontalPadding,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: kColorSilver, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeartAnimatedIcon(controller: controller),
          const SizedBox(width: 20.0),
          TextTitleLevelTwo(remainingHearts.toString()),
        ],
      ),
    );
  }
}

class HeartAnimatedIcon extends StatefulWidget {
  const HeartAnimatedIcon({super.key, this.controller});

  final UserHeartsController? controller;

  @override
  State<HeartAnimatedIcon> createState() => _HeartAnimatedIconState();
}

class _HeartAnimatedIconState extends State<HeartAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;

  final BubblesColor bubblesColor = const BubblesColor(
    dotPrimaryColor: Color(0xFFFFC107),
    dotSecondaryColor: Color(0xFFFF9800),
    dotThirdColor: Color(0xFFFF5722),
    dotLastColor: Color(0xFFF44336),
  );

  final circleColor = const CircleColor(
    start: Color(0xFFFF5722),
    end: Color(0xFFFFC107),
  );

  final Duration animationDuration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: animationDuration, vsync: this);
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _initControlAnimation();

    widget.controller?.addListener(() {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void didUpdateWidget(HeartAnimatedIcon oldWidget) {
    if (_controller.duration != animationDuration) {
      _controller.dispose();
      _controller =
          AnimationController(duration: animationDuration, vsync: this);
      _initControlAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 30.0;
    const bubblesSize = size * 2.0;
    const circleSize = size * 0.8;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext c, Widget? w) {
        const Widget likeWidget = Icon(
          CupertinoIcons.heart_fill,
          color: kColorOrange,
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
                  currentProgress: _bubblesAnimation.value,
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
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  circleColor: circleColor,
                ),
              ),
            ),
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: _controller.isAnimating ? _scaleAnimation.value : 1.0,
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

  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    final Animation<double> animate = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    _scaleAnimation = animate;
    _bubblesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
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
