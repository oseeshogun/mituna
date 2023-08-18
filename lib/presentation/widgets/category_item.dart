part of 'all.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    this.onPressed,
  });

  final QuestionCategory category;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed?.call(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
            painter: OreolPainter(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(category.asset),
                  fit: BoxFit.cover,
                ),
              ),
              height: 100,
              width: 100,
            ),
          ),
          const SizedBox(height: 10.0),
          TextTitleLevelTwo(category.title),
        ],
      ),
    );
  }
}
