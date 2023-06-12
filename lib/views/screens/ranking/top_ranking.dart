import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/ranking.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/views/widgets/all.dart';

import 'painters.dart';

class TopRanking extends StatelessWidget {
  const TopRanking(this.period, {super.key});

  final RankingPeriod period;

  Ranking? getFirstRanked(List<Ranking>? ranking) {
    if (ranking == null) return null;
    return ranking.isNotEmpty ? ranking.first : null;
  }

  Ranking? getSecondRanked(List<Ranking>? ranking) {
    if (ranking == null) return null;
    return ranking.length > 1 ? ranking[1] : null;
  }

  Ranking? getThirdRanked(List<Ranking>? ranking) {
    if (ranking == null) return null;
    return ranking.length > 2 ? ranking[2] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final topRanking = ref.watch(topRankingProvider(period));
        // final myRanking = ref.watch(myRankingProvider(period));
        final orderedRanking = topRanking;
        orderedRanking?.sort((a, b) => b.compareTo(a));
        return Positioned(
          top: MediaQuery.of(context).size.height * .13,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .51,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTopRanked(
                  uid: getSecondRanked(orderedRanking)?.uid,
                  ref: ref,
                  context: context,
                  score: getSecondRanked(orderedRanking)?.score.toString() ?? '',
                  height: MediaQuery.of(context).size.height * .22,
                  width: MediaQuery.of(context).size.width * .2,
                  color: kColorMarigoldYellow,
                  painter: RankSecondPainter(),
                  position: '2',
                  profilOffsetY: -100,
                ),
                buildTopRanked(
                  uid: getFirstRanked(orderedRanking)?.uid,
                  ref: ref,
                  context: context,
                  score: getFirstRanked(orderedRanking)?.score.toString() ?? '',
                  height: MediaQuery.of(context).size.height * .24,
                  width: MediaQuery.of(context).size.width * .2,
                  color: kColorYellow,
                  painter: RankFirstPainter(),
                  position: '1',
                  profilOffsetY: -120,
                ),
                buildTopRanked(
                  uid: getThirdRanked(orderedRanking)?.uid,
                  ref: ref,
                  context: context,
                  score: getThirdRanked(orderedRanking)?.score.toString() ?? '',
                  height: MediaQuery.of(context).size.height * .20,
                  width: MediaQuery.of(context).size.width * .2,
                  color: kColorEarlsGreen,
                  painter: RankThirdPainter(),
                  position: '3',
                  profilOffsetY: -100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildTopRanked({
  required String? uid,
  required String score,
  required WidgetRef ref,
  required BuildContext context,
  required double height,
  required double width,
  required double profilOffsetY,
  required Color color,
  required CustomPainter painter,
  required String position,
}) {
  if (uid == null) return Container();
  return ref.watch(specificUserDataProvider(uid)).when(
        loading: () => Container(),
        error: (error, stackTrace) {
          debugPrint(error.toString());
          return Container();
        },
        data: (ranked) {
          debugPrint(ranked.toString());
          return CustomPaint(
            painter: painter,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: color),
              child: Column(
                children: [
                  TopRankedProfil(
                    offsetY: profilOffsetY,
                    displayName: ranked?.displayName ?? '',
                    imageUrl: ranked?.imageUrl ?? UserObject.defaultImageUrl,
                  ),
                  TopRankedPosition(position: position),
                  TopRankedScore(score),
                ],
              ),
            ),
          );
        },
      );
}

class TopRankedProfil extends StatelessWidget {
  const TopRankedProfil({
    super.key,
    required this.imageUrl,
    required this.displayName,
    this.offsetY = -120,
  });

  final String imageUrl;
  final String displayName;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Column(
        children: [
          CustomPaint(
            painter: OreolPainter(),
            child: CachedNetworkImage(
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
          ),
          const SizedBox(height: 8.0),
          Text(
            displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TopRankedPosition extends StatelessWidget {
  const TopRankedPosition({
    super.key,
    this.offsetY = -80,
    required this.position,
  });

  final double offsetY;
  final String position;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
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
    );
  }
}

class TopRankedScore extends StatelessWidget {
  const TopRankedScore(
    this.score, {
    super.key,
    this.offsetY = -60,
  });

  final String score;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
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
          color: kColorSpice.withOpacity(.2),
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
    );
  }
}
