import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoTile extends StatefulWidget {
  final YoutubeVideo video;
  const YoutubeVideoTile(this.video, {super.key});

  @override
  State<YoutubeVideoTile> createState() => _YoutubeVideoTileState();
}

class _YoutubeVideoTileState extends State<YoutubeVideoTile> {
  late final YoutubePlayerController _controller;
  StreamSubscription<YoutubePlayerValue>? listener;

  final params = const YoutubePlayerParams(
        showFullscreenButton: true,
        mute: false,
        showControls: true,
        captionLanguage: 'fr',
        interfaceLanguage: 'fr',
      );

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.video.videoId,
      autoPlay: false,
      params: params,
    );
    listener = _controller.listen((event) {
      if (event.hasError) {
        _controller.load(params: params);
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.kScaffoldHorizontalPadding,
        vertical: AppSizes.kScaffoldHorizontalPadding * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: YoutubePlayer(
              controller: _controller,
              backgroundColor: AppColors.kColorMarigoldYellow,
              aspectRatio: 16 / 9,
            ),
          ),
          SizedBox(height: 10.0),
          TextDescription(
            widget.video.title,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
