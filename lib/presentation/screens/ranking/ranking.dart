import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/enums/all.dart';
import 'package:mituna/core/theme/colors.dart';
import 'package:mituna/core/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/ranking.dart';
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
    final rankings = ref.watch(rankingsProvider(period.value.name));

    fetch() => rewardsUsecase.getLeaderBoard(period.value);

    useEffect(() {
      loading.value = true;
      fetch().then((result) {
        result.fold((l) {
          loading.value = false;
          showOkAlertDialog(
            context: context,
            title: 'Une erreur est survenue',
            message: l.message,
          );
          failed.value = true;
        }, (r) {
          ref.read(rankingsProvider(period.value.name).notifier).state = r;
          loading.value = false;
        });
      });
      return null;
    }, [period.value]);

    final appBar = PrimaryAppBar(
      title: const TextTitleLevelOne('Classement Général'),
      actions: [
        IconButton(
          onPressed: () => fetch(),
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
                onPressed: () => fetch(),
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
          RestOfRanking(
            period,
            onPeriodChanged: onPeriodChanged,
          ),
        ],
      ),
    );
  }
}
