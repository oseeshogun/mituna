import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/youtube_videos.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:string_extensions/string_extensions.dart';

import 'youtube_video_tile.dart';

class YoutubeScreen extends HookConsumerWidget {
  const YoutubeScreen({super.key});

  static const route = '/youtube';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(watchCategoriesProvider);

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
          const SliverToBoxAdapter(child: SizedBox(height: 20.0)),
          switch (asyncCategories) {
            AsyncData(:final value) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = value[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
                          child: TextTitleLevelTwo(category.capitalize ?? ''),
                        ),
                        ref.watch(watchYoutubeVideosProvider(category)).when(
                              loading: () => const SizedBox(),
                              error: (error, stackTrace) => SizedBox(),
                              data: (videos) => SizedBox(
                                height: 200.0,
                                child: ListView.builder(
                                  itemCount: videos.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => YoutubeVideoTile(videos[index]),
                                ),
                              ),
                            ),
                        // ...category.videos.map((video) => YoutubeVideoTile(video: video)),
                      ],
                    );
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
