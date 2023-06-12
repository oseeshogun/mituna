import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/main.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/src/providers/ranking.dart';
import 'package:mituna/views/widgets/all.dart';

import 'rest_of_ranking.dart';
import 'top_ranking.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  static const route = '/ranking';

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  RankingPeriod period = RankingPeriod.all;
  bool loading = false;
  bool getDataFailed = false;
  final rewardsRepository = locator.get<RewardsRepository>();

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (shouldRefreshData) refreshData();
    });
  }

  Future<void> refreshData() async {
    if (loading == true) return;
    setState(() {
      loading = true;
      getDataFailed = false;
    });
    try {
      await rewardsRepository.getTopRanking(period);
      await rewardsRepository.getMyRanking(period);
    } catch (err) {
      debugPrint(err.toString());
      showOkAlertDialog(context: context, message: "Une erreur est survenue, Nous n'avons pas pu mettre à jour le classement.");
      if (mounted) {
        setState(() {
          getDataFailed = true;
        });
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  bool get shouldRefreshData {
    final topRanking = providerContainer.read(topRankingProvider(period));
    final myRanking = providerContainer.read(myRankingProvider(period));
    return topRanking == null || myRanking == null;
  }

  void onPeriodChanged(RankingPeriod value) {
    if (mounted) {
      setState(() {
        period = value;
      });
      if (shouldRefreshData) refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = PrimaryAppBar(
      title: const TextTitleLevelOne('Classement Général'),
      actions: [
        IconButton(
          onPressed: () => refreshData(),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );

    return Consumer(
      builder: (context, ref, child) {
        final topRanking = ref.watch(topRankingProvider(period));
        // final myRanking = ref.watch(myRankingProvider(period));
        debugPrint(topRanking.toString());
        if (loading) {
          return Scaffold(
            appBar: appBar,
            body: Column(
              children: [
                RankingPeriods(
                  currentPeriod: period,
                  onPeriodChanged: onPeriodChanged,
                ),
                Expanded(
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottiefiles/lf30_editor_hkwgqg68.json',
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (getDataFailed) {
          return Scaffold(
            appBar: appBar,
            body: Column(
              children: [
                RankingPeriods(
                  currentPeriod: period,
                  onPeriodChanged: onPeriodChanged,
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/svgs/Logic-cuate.svg',
                  height: MediaQuery.of(context).size.height * .3,
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
                  child: PrimaryButton(
                    backgroundColor: Colors.white,
                    child: const TextTitleLevelOne(
                      'Réessayer',
                      color: kColorBlueRibbon,
                    ),
                    onPressed: () => refreshData(),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: appBar,
          body: Stack(
            fit: StackFit.expand,
            children: [
              TopRanking(period),
              RestOfRanking(
                period,
                onPeriodChanged: onPeriodChanged,
              ),
            ],
          ),
        );
      },
    );
  }
}

class RankingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class RankingPeriods extends StatelessWidget {
  const RankingPeriods({
    super.key,
    required this.currentPeriod,
    required this.onPeriodChanged,
  });

  final RankingPeriod currentPeriod;
  final void Function(RankingPeriod) onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PeriodText(
            text: 'Cette semaine',
            period: RankingPeriod.week,
            currentPeriod: currentPeriod,
            onClick: onPeriodChanged,
          ),
          PeriodText(
            text: 'Ce mois',
            period: RankingPeriod.month,
            currentPeriod: currentPeriod,
            onClick: onPeriodChanged,
          ),
          PeriodText(
            text: 'Tout le temps',
            period: RankingPeriod.all,
            currentPeriod: currentPeriod,
            onClick: onPeriodChanged,
          ),
        ],
      ),
    );
  }
}
