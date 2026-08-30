part of 'all.dart';

class TopazIcon extends StatelessWidget {
  const TopazIcon({
    this.size = 30,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/icons8-topaze-48.png',
      height: size,
      width: size,
    );
  }
}
