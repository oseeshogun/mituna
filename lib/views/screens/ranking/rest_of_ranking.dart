import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/providers/ranking.dart';
import 'package:mituna/src/providers/user.dart';
import 'package:mituna/views/widgets/all.dart';

import 'global_ranking.dart';

class RestOfRanking extends StatefulWidget {
  const RestOfRanking(
    this.period, {
    super.key,
    required this.onPeriodChanged,
  });

  final RankingPeriod period;
  final void Function(RankingPeriod period) onPeriodChanged;

  @override
  State<RestOfRanking> createState() => _RestOfRankingState();
}

class _RestOfRankingState extends State<RestOfRanking> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: RankingPeriods(
            currentPeriod: widget.period,
            onPeriodChanged: widget.onPeriodChanged,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .35),
        Expanded(
          child: ClipPath(
            clipper: RankingClipper(),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(
                top: 10.0,
                left: kScaffoldHorizontalPadding,
                right: kScaffoldHorizontalPadding,
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  final topRanking = ref.watch(topRankingProvider(widget.period));
                  final myRanking = ref.watch(myRankingProvider(widget.period));
                  final orderedRanking = topRanking;
                  orderedRanking?.sort((a, b) => b.compareTo(a));
                  if (orderedRanking == null) {
                    return ListOfRestRanking(const [], ref: ref);
                  }
                  final isUserInTheTop30 = orderedRanking.length > 3 && orderedRanking.any((element) => element.uid == uid);
                  if (orderedRanking.length <= 3) {
                    return ListOfRestRanking(const [], ref: ref);
                  }
                  return ListOfRestRanking(
                    [
                      ...orderedRanking.sublist(3, orderedRanking.length).map<Ranking>(
                            (g) => Ranking(
                              uid: g.uid,
                              score: g.score,
                              position: orderedRanking.indexOf(g) + 1,
                            ),
                          ),
                      if (!isUserInTheTop30 && myRanking != null)
                        ...orderedRanking.where((g) => g.uid == uid).map<Ranking>(
                              (g) => myRanking,
                            ),
                    ],
                    ref: ref,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PeriodText extends StatelessWidget {
  const PeriodText({
    super.key,
    required this.text,
    required this.period,
    required this.currentPeriod,
    required this.onClick,
  });

  final RankingPeriod period;
  final RankingPeriod currentPeriod;
  final String text;
  final void Function(RankingPeriod value) onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(period),
      child: Text(
        text,
        style: TextStyle(
          color: currentPeriod == period ? kColorBlueRibbon : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}

class ListOfRestRanking extends StatelessWidget {
  const ListOfRestRanking(
    this.ranking, {
    super.key,
    required this.ref,
  });

  final List<Ranking> ranking;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ranking.length,
      padding: const EdgeInsets.only(top: 30.0),
      itemBuilder: (context, index) {
        final ranked = ranking[index];
        return ref.watch(specificUserDataProvider(ranked.uid)).when(
              loading: () => Container(),
              error: (error, stackTrace) {
                debugPrint(error.toString());
                debugPrint(stackTrace.toString());
                return Container();
              },
              data: (userRanked) {
                if (userRanked == null) {
                  return Container();
                }
                return RankingItem(
                  position: ranked.position,
                  imageUrl: userRanked.imageUrl,
                  displayName: userRanked.displayName,
                  score: ranked.score,
                  date: userRanked.lastTimeWin,
                );
              },
            );
      },
    );
  }
}

class RankingItem extends StatelessWidget {
  const RankingItem({
    required this.imageUrl,
    required this.position,
    required this.displayName,
    required this.score,
    required this.date,
    super.key,
  });

  final int position;
  final int score;
  final String imageUrl;
  final String displayName;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.MMMMd();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 10.0),
          Text(
            (position).toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: kColorBlack,
            ),
          ),
          const SizedBox(width: 20.0),
          CachedNetworkImage(
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
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitleLevelTwo(
                  displayName,
                  color: kColorBlack,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const TopazIcon(size: 22.0),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: TextDescription(
                        score.toString(),
                        color: kColorBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            format.format(date),
            style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(.4)),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
