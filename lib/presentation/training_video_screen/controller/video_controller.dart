import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import '../../../routes/app_routes.dart';
import '../models/video_model.dart';

class VideoController extends GetxController {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  /// Observables
  RxBool isVideoInitialized = false.obs;
  RxInt selectedVideoIndex = 0.obs;
  RxBool hasWatchedAllVideos = false.obs;
  RxBool allVideosUploaded = false.obs;
  RxBool allImagesUploaded = false.obs;
  RxList<VideoModal> videoList = <VideoModal>[].obs;
  RxBool ShowBtn = false.obs;
  var URL = dotenv.get("API_URL", fallback: "");

  @override
  void onInit() {
    super.onInit();
    fetchTrainingVideo().whenComplete(() => initializeVideo(0));
  }

  /// Fetches training videos from the API based on the user's language code.
  Future<void> fetchTrainingVideo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var code = prefs.getString('LangCode');
    try {
      var response = await http.get(Uri.parse(URL + '/api/video/get?code=${code}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];
        List<VideoModal> videos = data.map((item) => VideoModal.fromJson(item)).toList();
        videoList.value = videos;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Updates the user's video watched status.
  Future<void> ShowVideo(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.post(
        Uri.parse(URL + '/api/video/updateUserVideosWatchedStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": prefs.getString('userId'),
          "status": val,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        prefs.setBool('videosWatched', json['user']['videosWatched']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Initializes the video player.
  void initializeVideo(int index) {
    selectedVideoIndex.value = index;
    videoPlayerController = VideoPlayerController.network(videoList[selectedVideoIndex.value].fileUrl)
      ..addListener(() {
        if (videoPlayerController!.value.position.inMinutes == videoPlayerController!.value.duration.inMinutes) {
          videoList[selectedVideoIndex.value].watched = true;
          update();
          checkIfWatchedAllVideos();
        }
      });

    videoPlayerController!.initialize().then((_) {
      videoPlayerController!.setLooping(true);
      isVideoInitialized.value = true;
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        showOptions: false,
      );
      update();
      checkIfWatchedAllVideos();
    }).catchError((error) {
      print(error);
    });
  }

  /// Checks if all videos have been watched.
  void checkIfWatchedAllVideos() {
    hasWatchedAllVideos.value = videoList.every((element) => element.watched == true);
  }

  /// Plays the video at the specified index.
  void playVideoAtIndex(int index) {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    initializeVideo(index);
  }

  /// Navigates to the homepage screen.
  void onTapButton() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    Get.toNamed(AppRoutes.homepageOneScreen);
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}

