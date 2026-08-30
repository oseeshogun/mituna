part of 'all.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({
    required this.imageUrl,
    required this.position,
    required this.displayName,
    required this.score,
    required this.date,
    this.highlighted = false,
    super.key,
  });

  final int position;
  final int score;
  final String imageUrl;
  final String displayName;
  final DateTime date;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.MMMMd();

    return Container(
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.kColorBlueRibbon.withAlpha((.08 * 255).toInt())
            : null,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const SizedBox(width: 10.0),
          Text(
            (position).toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: AppColors.kColorBlack,
            ),
          ),
          const SizedBox(width: 20.0),
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                radius: 26.0,
                backgroundImage: imageProvider,
              );
            },
            placeholder: (context, url) => const SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitleLevelTwo(
                  displayName,
                  color: AppColors.kColorBlack,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const TopazIcon(size: 22.0),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: TextDescription(
                        score.toString(),
                        color: AppColors.kColorBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            format.format(date),
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black.withAlpha((.4 * 255).toInt())),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
