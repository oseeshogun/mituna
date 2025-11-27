///Class for returning a thumbnail of a youtube video
class YoutubeThumbnail {
  String? _id;

  /// Returns the YouTube video ID.
  YoutubeThumbnail({required String youtubeId}) {
    _id = youtubeId;
  }

  ///Return (maxresdefault) image as size of 1280x720
  String hd() {
    return 'https://img.youtube.com/vi/$_id/hqdefault.jpg';
  }

  ///Return (sddefault) image as size of 640x480
  String standard() {
    return 'https://img.youtube.com/vi/$_id/sddefault.jpg';
  }

  ///Return (hqdefault) image as size of 480x360
  String hq() {
    return 'https://img.youtube.com/vi/$_id/hqdefault.jpg';
  }

  ///Return (mqdefault) image as size of 320x180
  String mq() {
    return 'https://img.youtube.com/vi/$_id/mqdefault.jpg';
  }

  //Return (default) image as size of 120x90
  String small() {
    return 'https://img.youtube.com/vi/$_id/default.jpg';
  }
}
