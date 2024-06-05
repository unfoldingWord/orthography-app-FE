import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/homepage_screen/controller/homepage_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../models/image_gallery_modal_class.dart';

class ImageGalleryController extends GetxController {

  /// Observable variables for managing states
  RxInt selectedImgIndex = 0.obs; /// Index of the selected image
  RxBool isImgCompleted = false.obs; /// Indicates if image processing is completed
  RxBool isEditBtnClicked = false.obs; /// Indicates if edit btn is clicked or not to render text conditionally in sound groups
  RxBool isBtnSelected = false.obs; /// Indicates if a button is selected
  RxBool isTrainingBtnSelected = false.obs; /// Indicates if the training button is selected
  RxBool isVideoInitialized = false.obs; /// Indicates if the video player is initialized
  RxBool isLoading = false.obs; /// Indicates if data is loading
  RxList<ImageGalleryItems> imageGalleryList = <ImageGalleryItems>[].obs; /// List of image gallery items

  RxInt isSubmitBtnClicked = 0.obs; /// Indicates if data is loading
  RxString videoUrl = ''.obs; /// URL of the video
  var counter = 0.obs; /// Counter variable
  var currentPage = 1.obs;
  var shouldKeyPad = false.obs; /// Indicates if the keypad should be displayed
  var btnClicked = false.obs; /// Indicates if the keypad should be displayed

  /// Controllers and FocusNode for text input and video playback
  TextEditingController textController = TextEditingController(); /// Controller for text input
  FocusNode focusNode = FocusNode(); /// Focus node for managing focus

  late VideoPlayerController videoPlayerController; /// Controller for video playback
  late ChewieController chewieController; /// Controller for Chewie video player

  var URL = dotenv.get("API_URL", fallback: ""); /// URL for API calls retrieved from environment variables

  final ScrollController imageScrollController = ScrollController();


  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /// Update the observable variables with values from SharedPreferences
    isEditBtnClicked.value = prefs.getBool("isEditButtonClicked")!;
    update();
  }


  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    textController.text = '0';
    isBtnSelected.value = false;
    fetchTrainingVideo();
    fetchImages(Get.context!,page: currentPage.value);
    imageScrollController.addListener(onScroll);
    update();
  }
  void onScroll() {
    if (imageScrollController.position.atEdge && imageScrollController.position.pixels != 0) {
      if (!isLoading.value) {
          currentPage.value=currentPage.value+1;
          update();
          if(currentPage>9){

          }else{
            print('uuuuuuuuuu ${currentPage.value}');
            fetchImages(Get.context!, page: currentPage.value + 1);
          }

      }
    }
  }

  @override
  void dispose() {
    /// Dispose the video controller
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  void updateVideoStatus(val) {
    /// Update the training video button state
    isTrainingBtnSelected.value = val;
    update();
  }



  void updateVal(val) {
    shouldKeyPad.value = true;
    update();
  }

  void updateButton(val) {
    btnClicked.value = true;
    update();
  }


  void updateCounterVal(val) {
    counter.value = val;
    update();
  }

  void initializeVideo() {
    /// Initialize the training video
    if (videoUrl.value == '') {
      isVideoInitialized.value = false;
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl.value));
      videoPlayerController?.initialize().then((_) {
        videoPlayerController?.setLooping(true);
        isVideoInitialized.value = true;
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: false,
          showOptions: false,
        );
        update();
      }).catchError((error) {
        print(error);
      });
    }
  }

  /// Fetch image gallery list from the API
  Future<void> fetchImages(BuildContext context,{required int page}) async {
    /// Set isLoading to true to indicate that data is being loaded
    isLoading.value = true;
    /// Get the user ID and language code from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    print(userId);
    var CODE = prefs.getString('LangCode');
    try {
      /// Send a GET request to fetch image gallery data
      print('${URL}' + '/api/image/get?code=${CODE}&userId=${userId}&page=${currentPage.value}');
      var response = await http.get(Uri.parse(URL + '/api/image/get?code=${CODE}&userId=${userId}&page=${currentPage.value}'));
      /// Decode the response body into a map
      Map<String, dynamic> responseData = json.decode(response.body);
      /// Check if the request was successful
      if (response.statusCode == 200) {
        /// Extract image data from the response
        List<dynamic> data = responseData['data'];
        /// Convert the dynamic list to a list of ImageGalleryItems objects
        List<ImageGalleryItems> imageGalleryItems = data.map((item) => ImageGalleryItems.fromJson(item)).toList();
        /// Update the imageGalleryList with the fetched data
        // imageGalleryList.value = imageGalleryItems;

        if (page == 1) {
          imageGalleryList.value = imageGalleryItems;
        } else {
          imageGalleryList.addAll(imageGalleryItems);  /// Append new items to the existing list
        }

        isImgCompleted.value = imageGalleryList.every((element) => element.completed == true);
        /// Set isLoading to false since data loading is complete
        isLoading.value = false;

        if (imageGalleryList.isNotEmpty) {
          currentPage.value = page;  /// Update the current page
        }
        /// Trigger an update to reflect changes in the UI
        update();
      } else {
        /// If the request was not successful, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
          ),
        );
        /// Will Remove the error message after 1 second
        Timer(Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        /// Throw an exception for failed data loading
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e}'),
        ),
      );
      print('Error: $e');
    }
  }

  /// Submit syllables to API
  Future<void> submitSyllables(BuildContext context, id, count) async {
    /// Get the user ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    /// Check if the counter value is 0
    if (counter.value == 0) {
      /// If the counter value is 0, show a snackbar prompting to add syllable
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Add Syllable'),
        ),
      );
      /// Remove the snackbar after 1 second
      Timer(Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      });
    } else {
      try {
        isSubmitBtnClicked.value=1;
        update();
        /// Send a POST request to submit syllables
        var response = await http.post(
          Uri.parse(URL + '/api/syllable/assignSyllable'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "userId": userId,
            "image": {"_id": id, "count": count},
          }),
        );
        /// Check if the request was successful
        if (response.statusCode == 200 || response.statusCode == 201) {
          /// If successful, fetch images and handle next image
          final Map<String, dynamic> json = jsonDecode(response.body);
          print('JSONNNN ${json}');
          // fetchImages(Get.context!,page: currentPage.value).whenComplete(() => nextImgHandler());
          nextImgHandler();
          /// Set a boolean value in SharedPreferences to indicate syllable group opened
          prefs.setBool('isSyllableGrpOpened', true);
        } else {
          /// If not successful, show error message and handle accordingly
          final Map<String, dynamic> json = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(json['message']),
            ),
          );
          /// Will Remove the error message after 1 second
          Timer(Duration(seconds: 1), () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          });
          /// Throw an exception for failed data loading
          throw Exception('Failed to load data');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${e}'),
          ),
        );
        print('Error: $e');
      }
    }
  }

  /// Skip image API call
  Future<void> skipImage(BuildContext context, id) async {
    /// Get the user ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// Send a POST request to skip the image
      var response = await http.post(
        Uri.parse(URL + '/api/syllable/skipImage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"userId": userId, "imageId": id, "skip": true}),
      );

      /// Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// If successful, fetch images and handle next image
        final Map<String, dynamic> json = jsonDecode(response.body);
        fetchImages(Get.context!,page: currentPage.value);
        nextImgHandler();
      } else {
        /// If not successful, show error message and handle accordingly
        final Map<String, dynamic> json = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );
        /// Will Remove the error message after a delay
        Timer(Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        /// Throw an exception for failed data loading
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Fetch the training video from the API
  Future<void> fetchTrainingVideo() async {
    try {
      /// Send a GET request to fetch the training video
      var response = await http.get(Uri.parse(URL + '/api/syllable/getTrainingVideo'));
      /// Check if the request was successful
      if (response.statusCode == 200) {
        /// Decode the response body into a map
        var res = jsonDecode(response.body);
        /// Extract the video URL from the response and assign it to videoUrl
        videoUrl.value = res['data']['fileUrl'];
      } else {
        /// If the request was not successful, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print and handle any errors that occur during the process
      print('Error: $e');
    }
  }

  /// Updates States
  void updateOnTapValue() {
    /// Update and set image counter value state
    imageGalleryList[selectedImgIndex.value].onTap = counter.value;
    imageGalleryList[selectedImgIndex.value].onTap = int.parse(textController.text);
    update();
  }

  /// Handle next image
  void nextImgHandler() {
    isSubmitBtnClicked.value=0;
    update();
    /// Check if all images are completed
    isImgCompleted.value = imageGalleryList.every((element) => element.completed == true);
    update();

    /// Check if the current image is the last one
    if (selectedImgIndex.value == imageGalleryList.length - 1) {
      /// Find the index of the next incomplete image
      int nextIncompleteIndex = imageGalleryList.indexWhere((element) => element.completed == false, 0);

      /// If there is an incomplete image, move to it
      if (nextIncompleteIndex != -1) {
        selectedImgIndex.value = nextIncompleteIndex;
        counter.value = imageGalleryList[selectedImgIndex.value].onTap;
        textController.text = imageGalleryList[selectedImgIndex.value].onTap.toString();
      } else {
        print('No more incomplete images');
      }
    } else if (imageGalleryList[selectedImgIndex.value + 1].completed == false) {
      /// If the next image is incomplete, move to it
      selectedImgIndex.value = selectedImgIndex.value + 1;
      counter.value = imageGalleryList[selectedImgIndex.value].onTap;
      textController.text = imageGalleryList[selectedImgIndex.value].onTap.toString();
    } else {
      /// Find the index of the next incomplete image after the current one
      int nextIncompleteIndex = imageGalleryList.indexWhere((element) => element.completed == false,
        selectedImgIndex.value + 1);

      /// If there is an incomplete image, move to it
      if (nextIncompleteIndex != -1) {
        selectedImgIndex.value = nextIncompleteIndex;
        counter.value = imageGalleryList[selectedImgIndex.value].onTap;
        textController.text = imageGalleryList[selectedImgIndex.value].onTap.toString();
      } else {
        print('No more incomplete images');
      }
    }
  }

  /// Handle previous image
  void previousImgHandler() {
    /// Handle previous image
    int prevIndex = selectedImgIndex.value - 1;
    while (prevIndex >= 0) {
      if (!imageGalleryList[prevIndex].completed) {
        selectedImgIndex.value = prevIndex;
        counter.value = imageGalleryList[selectedImgIndex.value].onTap;
        textController.text = imageGalleryList[selectedImgIndex.value].onTap.toString();
        return;
      }
      prevIndex--;
    }
  }

  void disposeVideoPlayer() {
    /// Dispose the video player
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
