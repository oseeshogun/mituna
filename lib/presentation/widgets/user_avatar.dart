part of 'all.dart';

class UserAvatar extends HookWidget {
  UserAvatar({
    super.key,
    required this.avatar,
    this.onUpdateImage,
    this.errorWidget,
  });

  final String avatar;
  final Widget? errorWidget;
  final Function(ValueNotifier<bool> loading)? onUpdateImage;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    final container = Container(
      decoration: BoxDecoration(
        color: AppColors.kColorBlack.withAlpha((.2 * 255).toInt()),
        shape: BoxShape.circle,
      ),
      child: Visibility(
        visible: !loading.value,
        replacement: const CircularProgressIndicator(color: AppColors.kColorYellow),
        child: IconButton(
          icon: Icon(
            CupertinoIcons.camera_fill,
            color: Colors.white.withAlpha((.5 * 255).toInt()),
            size: 30.0,
          ),
          onPressed: () => onUpdateImage?.call(loading),
        ),
      ),
    );

    return Align(
      alignment: Alignment.center,
      child: CachedNetworkImage(
        imageUrl: avatar,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width * .4,
            height: MediaQuery.of(context).size.width * .4,
            child: onUpdateImage != null ? container : null,
          );
        },
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => errorWidget ?? container,
      ),
    );
  }
}
