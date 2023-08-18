part of 'all.dart';

class PrimaryRadioButton<T> extends StatelessWidget {
  const PrimaryRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
    this.forceSelected = false,
    this.radioIcon,
    this.selectRadioIcon,
    this.textColor = Colors.white,
    this.selectedTextColor = AppColors.kColorBlack,
    this.fillColor = Colors.transparent,
    this.selectedFillColor = AppColors.kColorYellow,
    this.borderColor = Colors.white,
    this.selectedBorderColor = AppColors.kColorYellow,
    this.radioBorderColor = Colors.white,
    this.selectedRadioBorderColor = AppColors.kColorBlueRibbon,
    this.radioFillColor = Colors.transparent,
    this.selectedRadioFillColor = AppColors.kColorBlueRibbon,
    Key? key,
  }) : super(key: key);

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String text;
  final Widget? radioIcon;
  final Widget? selectRadioIcon;
  final Color textColor;
  final Color selectedTextColor;
  final Color fillColor;
  final Color selectedFillColor;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color radioBorderColor;
  final Color selectedRadioBorderColor;
  final Color radioFillColor;
  final Color selectedRadioFillColor;

  final bool forceSelected;

  @override
  Widget build(BuildContext context) {
    final selected = forceSelected || value == groupValue;

    final appliedTextColor = selected ? selectedTextColor : textColor;
    final appliedFillColor = selected ? selectedFillColor : fillColor;
    final appliedBorderColor = selected ? selectedBorderColor : borderColor;
    final appliedRadioBorderColor = selected ? selectedRadioBorderColor : radioBorderColor;
    final appliedRadioFillColor = selected ? selectedRadioFillColor : radioFillColor;

    final defaultRadioIcon = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appliedRadioFillColor,
        border: Border.all(color: appliedRadioBorderColor),
      ),
      height: 20.0,
      width: 20.0,
    );

    return GestureDetector(
      onTap: () {
        if (!selected) onChanged?.call(value);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appliedFillColor,
          border: Border.all(color: appliedBorderColor),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 12.0,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Expanded(
              child: TextTitleLevelTwo(
                text,
                textAlign: TextAlign.left,
                color: appliedTextColor,
              ),
            ),
            if (selected && selectRadioIcon != null) selectRadioIcon! else radioIcon ?? defaultRadioIcon,
          ],
        ),
      ),
    );
  }
}
