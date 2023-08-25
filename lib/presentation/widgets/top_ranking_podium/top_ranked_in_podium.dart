import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/presentation/utils/painters/all.dart';
import 'package:mituna/presentation/widgets/all.dart';

class TopRankedInPodium extends HookConsumerWidget {
  const TopRankedInPodium({
    super.key,
    required this.uid,
    required this.score,
    required this.height,
    required this.width,
    required this.profilOffsetY,
    required this.color,
    required this.painter,
    required this.position,
  });

  final String? uid;
  final String score;
  final double height;
  final double width;
  final double profilOffsetY;
  final Color color;
  final CustomPainter painter;
  final String position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreUserStream = ref.watch(firestoreUserDataProvider(uid ?? 'no-user'));

    return CustomPaint(
      painter: painter,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: color),
        child: Column(
          children: [
            Transform.translate(
              offset: Offset(0, profilOffsetY),
              child: Column(
                children: [
                  firestoreUserStream.when(
                    loading: () => Container(),
                    error: (error, stackTrace) {
                      debugPrint(error.toString());
                      debugPrint(stackTrace.toString());
                      return Container();
                    },
                    data: (firestoreUser) {
                      return CustomPaint(
                        painter: OreolPainter(),
                        child: CachedNetworkImage(
                          imageUrl: firestoreUser?.avatar ?? 'no-avatar',
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
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  firestoreUserStream.when(
                    loading: () => Container(),
                    error: (error, stackTrace) {
                      debugPrint(error.toString());
                      debugPrint(stackTrace.toString());
                      return Container();
                    },
                    data: (firebaseUser) {
                      return Text(
                        firebaseUser?.displayName ?? '---',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -80),
              child: Text(
                position,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  shadows: [
                    Shadow(
                      offset: Offset(-2.0, 2.0),
                      blurRadius: 18.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -60),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 6.0,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 1.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: AppColors.kColorSpice.withOpacity(.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TopazIcon(size: 20.0),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: Text(
                        score,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
