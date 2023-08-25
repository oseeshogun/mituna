part of 'all.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final void Function()? onTap;

  ShapeBorder get listTileShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: listTileShape,
      leading: leading,
      title: TextTitleLevelTwo(
        title,
        textAlign: TextAlign.left,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white38,
              ),
            ),
      onTap: onTap,
    );
  }
}
