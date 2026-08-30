import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/entities/ranking.dart';
import 'package:mituna/domain/riverpod/providers/leaderboard.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/presentation/screens/auth/authentication.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:tuple/tuple.dart';

class RankingScreen extends HookConsumerWidget {
  const RankingScreen({super.key});

  static const route = '/ranking';

  Ranking? _at(List<Ranking> list, int index) =>
      index < list.length ? list[index] : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topAsync = ref.watch(leaderboardTopProvider);
    final myRankAsync = ref.watch(myLeaderboardRankProvider);
    final isAnonymous =
        ref.watch(firebaseAuthUserStreamProvider).value?.isAnonymous ?? false;

    void refresh() {
      ref.invalidate(leaderboardTopProvider);
      ref.invalidate(myLeaderboardRankProvider);
    }

    Future<void> openAuth() async {
      await Navigator.of(context).pushNamed(AuthenticationScreen.route);
      refresh();
    }

    final appBar = PrimaryAppBar(
      title: const TextTitleLevelOne('Classement'),
      actions: [
        IconButton(
          onPressed: refresh,
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: topAsync.when(
        loading: () => Center(
          child: Lottie.asset('assets/lottiefiles/lf30_editor_hkwgqg68.json'),
        ),
        error: (error, _) => _RankingMessage(
          asset: 'assets/svgs/Logic-cuate.svg',
          message: 'Une erreur est survenue',
          onRetry: refresh,
        ),
        data: (rankings) {
          if (rankings.isEmpty) {
            return _RankingMessage(
              asset: 'assets/svgs/Logic-cuate.svg',
              message:
                  'Personne n\'a encore marqué de topaze.\nGagne un sprint pour ouvrir le bal !',
              footer: isAnonymous ? _AnonymousCta(onPressed: openAuth) : null,
            );
          }

          final rest =
              rankings.length > 3 ? rankings.sublist(3) : const <Ranking>[];

          return Stack(
            fit: StackFit.expand,
            children: [
              TopRankingPodium(
                podium: Tuple3(
                    _at(rankings, 0), _at(rankings, 1), _at(rankings, 2)),
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .40),
                  Expanded(
                    child: ClipPath(
                      clipper: RankingClipper(),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: AppSizes.kScaffoldHorizontalPadding,
                          right: AppSizes.kScaffoldHorizontalPadding,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            if (isAnonymous)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: _AnonymousCta(onPressed: openAuth),
                              )
                            else
                              myRankAsync.maybeWhen(
                                data: (rank) => rank == null
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: TextTitleLevelTwo(
                                          'Votre rang : #$rank',
                                          color: AppColors.kColorBlueRibbon,
                                        ),
                                      ),
                                orElse: () => const SizedBox.shrink(),
                              ),
                            Expanded(
                              child: rest.isEmpty
                                  ? const Center(
                                      child: TextDescription(
                                        'Pas encore d\'autres joueurs classés.',
                                        color: AppColors.kColorBlack,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () async => refresh(),
                                      child: ListView.builder(
                                        itemCount: rest.length,
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 20.0),
                                        itemBuilder: (context, index) {
                                          final ranked = rest[index];
                                          return RankingItem(
                                            position: ranked.ranking,
                                            imageUrl: ranked.avatar,
                                            displayName: ranked.displayName,
                                            score: ranked.score,
                                            date: ranked.lastWinDate,
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RankingMessage extends StatelessWidget {
  const _RankingMessage({
    required this.asset,
    required this.message,
    this.onRetry,
    this.footer,
  });

  final String asset;
  final String message;
  final VoidCallback? onRetry;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.kScaffoldHorizontalPadding,
          vertical: 24.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(asset,
                height: MediaQuery.of(context).size.height * .3),
            const SizedBox(height: 30.0),
            TextTitleLevelTwo(message),
            if (onRetry != null) ...[
              const SizedBox(height: 30.0),
              PrimaryButton(
                backgroundColor: Colors.white,
                onPressed: onRetry,
                child: const TextTitleLevelOne('Réessayer',
                    color: AppColors.kColorBlueRibbon),
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: 30.0),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class _AnonymousCta extends StatelessWidget {
  const _AnonymousCta({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.kColorBlueRibbon.withAlpha((.08 * 255).toInt()),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TextDescription(
            'Tu joues sans compte. Connecte-toi pour apparaître dans le classement.',
            color: AppColors.kColorBlack,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          PrimaryButton(
            onPressed: onPressed,
            child: const TextTitleLevelTwo('Se connecter',
                color: AppColors.kColorBlack),
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
