part of 'all.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const PrimaryAppBar({
    Key? key,
    this.leading,
    this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// This part is copied from AppBar class
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? leadingIcon = leading;

    if (leadingIcon == null && automaticallyImplyLeading) {
      if (hasDrawer) {
        leadingIcon = IconButton(
          icon: const Icon(Icons.mood_sharp, color: Colors.yellowAccent),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      } else {
        if (canPop) {
          leadingIcon = GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
                color: Colors.transparent,
              ),
              margin: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          );
        }
      }
    }

    return AppBar(
      elevation: 0.0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      leading: leadingIcon,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
