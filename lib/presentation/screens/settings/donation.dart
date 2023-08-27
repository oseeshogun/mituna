import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/core/presentation/hooks/use_confetti_controller.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/presentation/utils/painters/draw_star.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:url_launcher/url_launcher.dart';

class Donation extends HookWidget {
  const Donation({super.key});

  static const route = '/donation';

  @override
  Widget build(BuildContext context) {
    final bottomLeftController = useConfettiController();
    final bottomRightController = useConfettiController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        bottomLeftController.play();
        bottomRightController.play();
      });
      return null;
    }, []);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/katt-yukawa-K0E6E0a0R3A-unsplash.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black38,
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const FadeAnimation(
                            delay: 1.0,
                            child: PrimaryAppBar(),
                          ),
                          const SizedBox(height: 20.0),
                          FadeAnimation(
                            delay: 1.0,
                            child: SvgPicture.asset(
                              'assets/svgs/Christmas charity-bro.svg',
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const FadeAnimation(
                            delay: 1.0,
                            child: Text(
                              'Faîtes un don qui compte',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          const FadeAnimation(
                            delay: 1.5,
                            child: Text.rich(
                              TextSpan(
                                text: "Nous sommes fiers d’être congolais et d'innover à but non lucratif,",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text:
                                          ' des personnes comme vous nous aident à défendre la bonne santé de la tech en RDC. Nous comptons sur vos dons pour achever notre mission.')
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          FadeAnimation(
                            delay: 2.0,
                            child: Image.asset(
                              'assets/images/mpesa_logo.png',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const FadeAnimation(
                            delay: 2.0,
                            child: TextTitleLevelOne('+243 827 293 556'),
                          ),
                          const SizedBox(height: 40.0),
                          FadeAnimation(
                            delay: 2.5,
                            child: InkWell(
                              onTap: () => launchUrl(Uri.parse('https://www.buymeacoffee.com/omasuakuH'), mode: LaunchMode.externalApplication),
                              child: Image.asset('assets/images/bmc-button.png', width: 200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ConfettiWidget(
                    confettiController: bottomLeftController,
                    blastDirection: -pi / 3,
                    emissionFrequency: 0.01,
                    numberOfParticles: 40,
                    maxBlastForce: 100,
                    minBlastForce: 80,
                    gravity: 0.3,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ConfettiWidget(
                    confettiController: bottomRightController,
                    blastDirection: 2 * pi / 3,
                    blastDirectionality: BlastDirectionality.explosive,
                    createParticlePath: drawStar,
                    emissionFrequency: 0.01,
                    numberOfParticles: 60,
                    maxBlastForce: 100,
                    minBlastForce: 80,
                    gravity: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
