import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/theme/colors.dart';
import 'package:mituna/core/theme/sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

import 'authentication.dart';

class Welcome extends HookWidget {
  const Welcome({super.key});

  static const String route = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/Customer Survey-pana.svg',
                        height: 200,
                      ),
                      const SizedBox(height: 10),
                      const TextTitleLevelOne('Mutuna'),
                      const SizedBox(height: 10),
                      const TextDescription(
                        'Testez vos connaissances sur la République Démocratique du Congo et le Monde.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                child: const TextTitleLevelOne('Commencer', color: AppColors.kColorBlack),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Authentication.route);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
