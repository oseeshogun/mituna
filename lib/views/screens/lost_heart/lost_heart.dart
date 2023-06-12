import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/views/widgets/all.dart';

class LostHeart extends StatefulWidget {
  const LostHeart({
    super.key,
    required this.remainingHearts,
  });

  final int remainingHearts;

  static const String route = '/lost_heart';

  @override
  State<LostHeart> createState() => _LostHeartState();
}

class _LostHeartState extends State<LostHeart> {
  final int countDownTime = 5;

  // This function will be called when the timer ends
  void onEnd() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        actions: [
          UserHearts(remainingHearts: widget.remainingHearts),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kScaffoldHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/Heartbroken-amico.svg',
                height: MediaQuery.of(context).size.height * .35,
              ),
              const Text(
                'Vous avez perdu un coeur',
                style: TextStyle(
                  fontSize: 36.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  text: 'Il vous reste ${widget.remainingHearts} ',
                  children: const [
                    WidgetSpan(
                      child: Icon(
                        CupertinoIcons.heart_fill,
                        color: kColorOrange,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ', faites plus attention à votre réponse.',
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CountDownTimeFromGame(
                countDownTime: countDownTime,
                onEnd: onEnd,
              ),
              const SizedBox(height: 12),
              CountDownBarAnimation(endTime: countDownTime),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
