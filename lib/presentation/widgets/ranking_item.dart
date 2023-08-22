part of 'all.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({
    required this.imageUrl,
    required this.position,
    required this.displayName,
    required this.score,
    required this.date,
    super.key,
  });

  final int position;
  final int score;
  final String imageUrl;
  final String displayName;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.MMMMd();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
            style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(.4)),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
