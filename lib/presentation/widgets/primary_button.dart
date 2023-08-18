part of 'all.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.child,
    required this.onPressed,
    this.loading = false,
    this.backgroundColor = AppColors.kColorYellow,
    this.foregroundColor = AppColors.kColorBlack,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0),
    Key? key,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Visibility(
        visible: !loading,
        replacement: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 40.0,
            width: 40.0,
            child: CircularProgressIndicator(
              color: backgroundColor,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            foregroundColor: MaterialStateProperty.all(foregroundColor),
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}