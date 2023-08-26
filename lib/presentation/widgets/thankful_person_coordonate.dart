part of 'all.dart';

class ThankfulPersonCoordonate extends StatelessWidget {
  const ThankfulPersonCoordonate({
    super.key,
    this.onTap,
    required this.asset,
    required this.title,
  });

  final void Function()? onTap;
  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(asset),
            const SizedBox(width: 20.0),
            Expanded(
              child: TextTitleLevelTwo(
                title,
                color: AppColors.kColorBlack,
                textAlign: TextAlign.left,
              ),
            ),
            const Icon(Icons.launch),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }
}
