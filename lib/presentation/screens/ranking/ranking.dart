import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/entities/firestore_user.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/riverpod/providers/ranking.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/domain/usecases/reward.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:tuple/tuple.dart';

class RankingScreen extends HookConsumerWidget {
  RankingScreen({super.key});

  static const route = '/ranking';

  final rewardsUsecase = RewardsUsecase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = useState(RankingPeriod.all);
    final loading = useState(false);
    final failed = useState(false);
    final rankings = ref.watch(rankingsNotifierProvider(period.value.name));

    fetch(bool force) {
      if (loading.value) return;
      loading.value = true;
      final stateValue = ref.read(rankingsNotifierProvider(period.value.name));
      if (stateValue.isNotEmpty && !force) {
        loading.value = false;
        return;
      }
      rewardsUsecase.topRankings(period.value).then((result) {
        result.fold((l) {
          showOkAlertDialog(
            context: context,
            title: 'Une erreur est survenue',
            message: l.message,
          );
          failed.value = true;
        }, (r) {
          ref.read(rankingsNotifierProvider(period.value.name).notifier).preppendAll(r);
        });
        loading.value = false;
      });
      rewardsUsecase.userRanking(period.value).then((result) {
        result.fold((l) {}, (r) {
          ref.read(rankingsNotifierProvider(period.value.name).notifier).appendAll(r);
        });
      });
    }

    useEffect(() {
      fetch(false);
      return null;
    }, [period.value]);

    final appBar = PrimaryAppBar(
      title: const TextTitleLevelOne('Classement Général'),
      actions: [
        IconButton(
          onPressed: () => fetch(true),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );

    if (loading.value) {
      return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            RankingPeriods(
              currentPeriod: period.value,
              onPeriodChanged: (value) => (period.value = value),
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
    } else if (failed.value) {
      return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            RankingPeriods(
              currentPeriod: period.value,
              onPeriodChanged: (value) => (period.value),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/svgs/Logic-cuate.svg',
              height: MediaQuery.of(context).size.height * .3,
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
              child: PrimaryButton(
                backgroundColor: Colors.white,
                child: const TextTitleLevelOne(
                  'Réessayer',
                  color: AppColors.kColorBlueRibbon,
                ),
                onPressed: () => fetch(true),
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
          TopRankingPodium(
            period: period.value,
            podium: Tuple3(
              rankings.firstOrNull,
              rankings.length > 2 ? rankings[1] : null,
              rankings.length > 3 ? rankings[2] : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: RankingPeriods(
                  currentPeriod: period.value,
                  onPeriodChanged: (value) => (period.value = value),
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
                      left: AppSizes.kScaffoldHorizontalPadding,
                      right: AppSizes.kScaffoldHorizontalPadding,
                    ),
                    child: Builder(builder: (context) {
                      final List<Ranking> list = rankings.length > 3 ? rankings.sublist(3, rankings.length) : [];
                      return ListView.builder(
                        itemCount: list.length,
                        padding: const EdgeInsets.only(top: 30.0),
                        itemBuilder: (context, index) {
                          final ranked = list[index];
                          return ref.watch(firestoreUserDataProvider(ranked.uid)).when(
                                loading: () => Container(),
                                error: (error, stackTrace) {
                                  debugPrint(error.toString());
                                  debugPrint(stackTrace.toString());
                                  return Container();
                                },
                                data: (FirestoreUser? userRanked) {
                                  if (userRanked == null) {
                                    return Container();
                                  }
                                  return RankingItem(
                                    position: ranked.ranking,
                                    imageUrl: userRanked.avatar,
                                    displayName: userRanked.displayName,
                                    score: ranked.topaz,
                                    date: userRanked.lastWinDate,
                                  );
                                },
                              );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
