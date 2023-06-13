import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/providers/sprint.dart';
import 'package:mituna/src/services/hive/hive_db.dart';
import 'package:mituna/views/widgets/all.dart';

import '../competition/infos.dart';
import 'wait_for_competition.dart';

class CompetitionCountDown extends StatefulWidget {
  const CompetitionCountDown({Key? key}) : super(key: key);

  @override
  State<CompetitionCountDown> createState() => _CompetitionCountDownState();
}

class _CompetitionCountDownState extends State<CompetitionCountDown> {
  static const String countDownHiveKey = 'competition_count_down';

  Timer? timer;
  Duration? duration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await updateCountDown();
      setCountDownDuration();
      startTimer();
    });
  }

  Future<void> updateCountDown() async {
    final hiveDatabase = await locator.getAsync<HiveDatabase>();
    final nextCompetitionTime = await locator.get<ApiRepository>().getNextCompetitionTime();
    nextCompetitionTime.fold((l) {
      // Retry 15 seconds later the request succeed
      Future.delayed(const Duration(seconds: 15), updateCountDown);
    }, (value) {
      hiveDatabase.userBox.put(countDownHiveKey, value);
    });
  }

  Future<void> setCountDownDuration() async {
    final hiveDatabase = await locator.getAsync<HiveDatabase>();
    final competitionTimeInMilliseconds = hiveDatabase.userBox.get(countDownHiveKey);
    if (competitionTimeInMilliseconds is! int) return;
    final competitionTime = DateTime.fromMillisecondsSinceEpoch(competitionTimeInMilliseconds);
    final timeNow = DateTime.now();
    if (mounted) {
      setState(() {
        duration = competitionTime.difference(timeNow);
      });
    }
  }

  void decrementTime() {
    if (duration == null) return;
    final durationInSeconds = duration!.inSeconds;
    if (durationInSeconds == 0) {
      return timer?.cancel();
    }
    if (mounted) {
      setState(() {
        duration = Duration(seconds: durationInSeconds - 1);
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => decrementTime(),
    );
  }

  String formatCompetitionTimeLeft(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}h ${twoDigitMinutes}min ${twoDigitSeconds}s';
  }

  int getCompetitionDaysLeft(Duration duration) {
    return duration.inDays;
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    void getMoreInfo() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const CompetitionInfo(),
      ));
    }

    void goToCompetitionPage() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const WaitForCompetition(),
      ));
    }

    if (duration == null) {
      return Container();
    } else if (duration!.inSeconds < 0) {
      return Container();
    }

    return Consumer(
      builder: (context, WidgetRef ref, child) {
        return ref.watch(competitionProvider).when(
              loading: () => Container(),
              error: (err, st) {
                debugPrint(err.toString());
                return Container();
              },
              data: (competition) {
                return Column(
                  children: [
                    if (competition?.pending == true && competition?.started == false)
                      ElevatedButton(
                        onPressed: () => goToCompetitionPage(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kColorYellow),
                          foregroundColor: MaterialStateProperty.all(kColorBlueRibbon),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 15.0,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                        child: const TextTitleLevelOne(
                          '🥇 Participer à la compétition',
                          color: kColorBlueRibbon,
                        ),
                      )
                    else ...[
                      const TextDescription('Compétion Global Motuna dans'),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CountDownItem(
                            value: duration!.inDays,
                            labelPlural: 'jours',
                            label: 'jour',
                          ),
                          CountDownItem(
                            value: duration!.inHours.remainder(24),
                            labelPlural: 'heures',
                            label: 'heure',
                          ),
                          CountDownItem(
                            value: duration!.inMinutes.remainder(60),
                            labelPlural: 'minutes',
                            label: 'minute',
                          ),
                          CountDownItem(
                            value: duration!.inSeconds.remainder(60),
                            labelPlural: 'secondes',
                            label: 'seconde',
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10.0),
                    InkWell(
                      onTap: () => getMoreInfo(),
                      child: const Text(
                        'Plus d’infos sur la compétition',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
      },
    );
  }
}

class CountDownItem extends StatelessWidget {
  const CountDownItem({
    Key? key,
    required this.value,
    required this.label,
    required this.labelPlural,
  }) : super(key: key);

  final int value;
  final String label;
  final String labelPlural;

  @override
  Widget build(BuildContext context) {
    final valueInString = value.toString().padLeft(2, '0');
    final displayedLabel = value < 2 ? label : labelPlural;

    return Column(
      children: [
        Text(
          valueInString,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 36.0,
            color: kColorYellow,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          displayedLabel,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: kColorYellow,
          ),
        ),
      ],
    );
  }
}
