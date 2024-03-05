import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/core/utils/youtube_thumbnail.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:url_launcher/url_launcher_string.dart';

class YoutubeVideoTile extends StatefulWidget {
  final YoutubeVideo video;
  const YoutubeVideoTile(this.video, {super.key});

  @override
  State<YoutubeVideoTile> createState() => _YoutubeVideoTileState();
}

class _YoutubeVideoTileState extends State<YoutubeVideoTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      margin: EdgeInsets.only(
        left: AppSizes.kScaffoldHorizontalPadding,
        right: AppSizes.kScaffoldHorizontalPadding * 2.5,
        top: AppSizes.kScaffoldHorizontalPadding * 2,
        bottom: AppSizes.kScaffoldHorizontalPadding * 2,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: YoutubeThumbnail(youtubeId: widget.video.videoId).hd(),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black38),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  onTap: () => launchUrlString('https://youtube.com/watch?v=${widget.video.videoId}'),
                ),
                const SizedBox(height: 8.0),
                TextDescription(
                  widget.video.title,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
