import 'dart:async';
import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../Identify_syllables_screens/models/syllable_modal_class.dart';
import 'package:http/http.dart' as http;

class SyllableGroupsController extends GetxController {
  RxBool isBtnSelected = false.obs;
  RxBool isTrainingBtnSelected = false.obs;
  RxInt selectedImgIndex = 0.obs;
  var counter = 0.obs;
  RxBool isImgCompleted = false.obs;
  var URL = dotenv.get("API_URL",fallback: "");
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  RxBool isVideoInitialized = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDataFetched = false.obs;
  RxString videoUrl = ''.obs;
  RxList<ImageItem> Monosyllables = <ImageItem>[].obs;
  RxList<ImageItem> Bisyllables = <ImageItem>[].obs;
  RxList<ImageItem> Trisyllables = <ImageItem>[].obs;
  RxList<ImageItem> Polysyllables = <ImageItem>[].obs;
  RxList<ImageResponse> syllableList = <ImageResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    isBtnSelected.value=false;
    fetchTrainingVideo();
    fetchData(Get.context!);
  }

  void updateVideoStatus(val) {
    isTrainingBtnSelected.value=val;
    update();
  }

  /// Function To Fetch Training video From API
  Future<void> fetchTrainingVideo() async {
    try {
      var response = await http.get(Uri.parse(URL+'/api/syllable/getTrainingVideo'));
      if (response.statusCode == 200) {
        var res=jsonDecode(response.body);
        videoUrl.value=res['data']['fileUrl'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Function To Initialize Training video
  void initializeVideo() {
    if(videoUrl.value=='')
    {
      isVideoInitialized.value=false;
    }
    else{
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl.value));
      videoPlayerController.initialize().then((_) {
        videoPlayerController.setLooping(true);
        isVideoInitialized.value = true;
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: true,

        );
        update();
      }).catchError((error){
        print(error);
      });
    }

  }

  /// Function To Fetch Syllable Gallery List From API
  Future<void> fetchData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId=prefs.getString('userId');
      var response = await http.get(Uri.parse(URL+'/api/syllable/syllableGallery?userId=${userId}'));
      Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        isDataFetched.value=true;
        final syllableResponse = ImageResponse.fromJson(json.decode(response.body));
        Monosyllables.value=syllableResponse.data.mono;
        Bisyllables.value=syllableResponse.data.bi;
        Trisyllables.value=syllableResponse.data.tri;
        Polysyllables.value=syllableResponse.data.poly;
        update();
      } else {
        /// Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
        Timer(Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      /// Handle exceptions
      print('Error fetching data: $e');
    }
  }

  /// Function To Assign Syllable To Image Using API
  Future<void> uploadSyllable(val,imgId,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId=prefs.getString('userId');
      var response = await http.post(Uri.parse(URL+'/api/syllable/updateSyllable'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId":userId,
          "imageId":imgId,
          "syllable" : val
        }),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      /// Update the observable variables with values from SharedPreferences
      if (response.statusCode == 200) {
        Get.back();
        prefs.setBool("isEditButtonClicked",prefs.getBool("btnClicked")!);
        Get.offAllNamed(AppRoutes.syllableGroupsScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
        Timer(Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ///  Exceptions Handling
      print('Error fetching data: $e');
    }
  }

  /// Function To Handle Next Image
  void previousImgHandler() {
    selectedImgIndex.value -= 1;
  }

}
