part of 'all.dart';

class CountDownTimeFromGame extends StatelessWidget {
  const CountDownTimeFromGame({
    super.key,
    required this.countDownTime,
    this.onEnd,
  });

  final int countDownTime;
  final void Function()? onEnd;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: countDownTime),
      tween: Tween(begin: Duration(seconds: countDownTime), end: Duration.zero),
      onEnd: onEnd,
      builder: (context, Duration duration, Widget? child) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text.rich(
            TextSpan(
              text: 'Le jeu continue dans ',
              children: [
                WidgetSpan(
                  child: Text(
                    duration.inSeconds.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const TextSpan(text: 's'),
              ],
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
        );
      },
    );
  }
}
