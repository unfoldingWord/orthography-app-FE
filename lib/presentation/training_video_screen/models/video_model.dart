import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoModal {
  final String id;
  final String fileUrl;
  final String title;
  final String thumbnailFileUrl;
  bool watched;

  VideoModal({
    required this.id,
    required this.fileUrl,
    required this.title,
    required this.thumbnailFileUrl,
    this.watched = false,
  });

  factory VideoModal.fromJson(Map<String, dynamic> json) {
    return VideoModal(
      id: json['_id'],
      fileUrl: json['fileUrl'],
      title: json['title'],
      thumbnailFileUrl: json['thumbnailFileUrl']

    );
  }
}

