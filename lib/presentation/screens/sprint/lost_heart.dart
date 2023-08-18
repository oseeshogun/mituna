import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/core/theme/colors.dart';
import 'package:mituna/core/theme/sizes.dart';
import 'package:mituna/presentation/widgets/all.dart';

class LostHeart extends HookWidget {
  const LostHeart({super.key, required this.remainingHearts});

  final int remainingHearts;

  @override
  Widget build(BuildContext context) {
    final countDownTime = useState(5);

    void onEnd() => Navigator.of(context).pop();
    return Scaffold(
      appBar: PrimaryAppBar(
        actions: [
          UserHearts(remainingHearts: remainingHearts),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.kScaffoldHorizontalPadding),
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
                  text: 'Il vous reste $remainingHearts',
                  children: const [
                    WidgetSpan(
                      child: Icon(
                        CupertinoIcons.heart_fill,
                        color: AppColors.kColorOrange,
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
                countDownTime: countDownTime.value,
                onEnd: onEnd,
              ),
              const SizedBox(height: 12),
              CountDownBarAnimation(endTime: countDownTime.value),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
