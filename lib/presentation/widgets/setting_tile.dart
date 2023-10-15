part of 'all.dart';

class SettingTile extends StatelessWidget {
  SettingTile({
    super.key,
    required this.leading,
    required this.title,
    this.onTap,
    this.onLongPress,
    this.foregroundColor = Colors.white,
  });

  final Widget leading;
  final String title;
  final Color foregroundColor;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      minLeadingWidth: 0.0,
      textColor: foregroundColor,
      iconColor: foregroundColor,
      title: TextTitleLevelTwo(
        title,
        textAlign: TextAlign.left,
        color: foregroundColor,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
