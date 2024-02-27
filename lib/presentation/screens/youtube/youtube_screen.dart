import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/youtube_videos.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

import 'youtube_video_tile.dart';

class YoutubeScreen extends HookConsumerWidget {
  const YoutubeScreen({super.key});

  static const route = '/youtube';

  // TODO: ask for age first

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVideos = ref.watch(watchYoutubeVideosProvider);

    return Scaffold(
      appBar: PrimaryAppBar(title: TextTitleLevelTwo('Youtube')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: SvgPicture.asset(
                'assets/svgs/Video-tutorial-amico.svg',
                height: 180,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TextDescription(
              'Des videos gratuits de Youtube',
              textAlign: TextAlign.center,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              padding: EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
              height: 50.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Rechercher...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          switch (asyncVideos) {
            AsyncData(:final value) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final video = value[index];
                    return YoutubeVideoTile(video);
                  },
                  childCount: value.length,
                ),
              ),
            AsyncError(:final error) => SliverToBoxAdapter(child: Text('error: $error')),
            _ => const SliverToBoxAdapter(child: Text('Chargement...')),
          }
        ],
      ),
    );
  }
}
