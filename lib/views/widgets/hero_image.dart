import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroImage extends StatelessWidget {
  final String imageAsset;
  const HeroImage({super.key, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(imageAsset);
  }
}
