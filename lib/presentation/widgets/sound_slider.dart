part of 'all.dart';

class SoundSlider extends HookWidget {
  const SoundSlider({
    super.key,
    required this.onChanged,
    required this.value,
  }): assert(value >= 0.0 && value <= 1.0, "The value must be between 0 and 1");

  final void Function(double)? onChanged;
  final double value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.volume_up,
        color: Colors.white,
      ),
      title: Row(
        children: [
          TextDescription((value * 100).floor().toString()),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorColor: AppColors.kColorBlueRibbon,
                valueIndicatorTextStyle: TextStyle(
                  color: AppColors.kColorBlack.withOpacity(.6),
                  fontWeight: FontWeight.bold,
                ),
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              ),
              child: Slider(
                value: value * 100,
                max: 100.0,
                divisions: 5,
                activeColor: AppColors.kColorYellow,
                label: (value * 100).floor().toString(),
                onChanged: (v) => onChanged?.call(v/100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
