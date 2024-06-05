import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/sound_groups_screens/controller/sound_groups_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../sound_grouping_screen/models/singleImg_sound_group_model.dart';

class LetterAssignmentController extends GetxController {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  /// Base URL for API calls, fetched from environment variables
  var URL = dotenv.get("API_URL", fallback: "");

  /// Observable list for storing assigned gallery items
  RxList assignSelectedGalleryList = RxList([].obs);

  ///Observables Declaration
  RxInt selectedImgIndex = 0.obs;

  RxList selectedImgIds = RxList([].obs);

  RxString selectedSoundGrpId = ''.obs;

  RxString selectedSoundGrpURL = ''.obs;

  RxBool isSGAssignmentCompleted = false.obs;

  RxBool isAssignmentFullyCompleted = false.obs;

  RxBool isSubmitButtonEnabled = false.obs;

  RxInt selectedGroupIndex = 0.obs;

  /// Controller for the single Grapheme text field
  TextEditingController assignLetterTextController = TextEditingController();

  SoundGroupsController soundGroupsController = Get.put(SoundGroupsController());

  @override
  void onInit() {
    super.onInit();
    scrollController2.addListener(_scrollListener);

  }

  void _scrollListener() {
    if (scrollController2.position.atEdge) {
      if (scrollController2.position.pixels == 0) {
        scrollController1.jumpTo(0);
      } else {
        scrollController1.jumpTo(scrollController1.position.maxScrollExtent);
      }
    }
  }

  @override
  void dispose() {
    scrollController1.dispose();
    scrollController2.removeListener(_scrollListener);
    scrollController2.dispose();
    super.dispose();
  }

  /// Function to handle the Submit Assign Letters
  Future<void> handleAssignLetters(BuildContext context, isGroupAssignment) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    try {
      /// Send a POST request
      var response = await http.post(Uri.parse(URL + '/api/grapheme/assignLetter'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": userId,
          "letter": assignLetterTextController.text,
          "imageIds": isGroupAssignment == true ? selectedImgIds.value :
                      [assignSelectedGalleryList[selectedImgIndex.value].imageId]
        }),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      /// If the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        Future.delayed(
          Duration(milliseconds: 500),
          () {
            fetchAssignLettersStatus(context).whenComplete(() {
              if (isAssignmentFullyCompleted.value == false) {
                fetchSoundGroupAssignLetters(context);
              }
            });
          },
        );

        if(isGroupAssignment==true){
          nextGroupHandler();
        }

        assignLetterTextController.text = '';
        isSubmitButtonEnabled.value=false;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error for debugging purposes
      print('Error: $e');
    }
  }

  /// Function To Handle next Image Set of SoundGroup List
  void nextGroupHandler() {
    soundGroupsController.fetchAllSoundGroups().whenComplete(() {
      bool hasIncomplete = soundGroupsController.AllSoundGroupList.every((element) =>
          element.imageList.every((e) =>
          e.assignLetterCompleted == true
          )
      );
      if(hasIncomplete)
        {
          Get.offAllNamed(AppRoutes.letterAssignmentGallery);
        }
    });
    if (selectedGroupIndex.value != soundGroupsController.AllSoundGroupList.length - 1)
    {
      int currentIndex = selectedGroupIndex.value;
      var selectedList = [];
      for (int i = currentIndex + 1; i < soundGroupsController.AllSoundGroupList.length; i++)
      {
        /// Checking for all the image's property assignLetterCompleted or not
        bool hasIncomplete = soundGroupsController.AllSoundGroupList[i].imageList.any((image) =>
        image.assignLetterCompleted == false);

        if (hasIncomplete) {
          selectedGroupIndex.value = i;
          for (int i = 0; i < soundGroupsController.AllSoundGroupList[selectedGroupIndex.value].imageList.length; i++)
          {
            selectedList.add(soundGroupsController.AllSoundGroupList[selectedGroupIndex.value].
            imageList[i].imageId);
          }
          updateImgIdsList(selectedList);
          return;
          /// Exit the function after finding the next incomplete SGImageList
        }
      }
      /// If no incomplete SGImageList is found after the current index
      print('No more incomplete SGImageList');
    }
  }

  /// Function To Handle previous Image Set of SoundGroup List
  void previousGroupHandler() {
    int currentIndex = selectedGroupIndex.value;
    var selectedList = [];
    for (int i = currentIndex - 1; i >= 0; i--) {
      bool hasIncomplete = soundGroupsController.AllSoundGroupList[i].imageList.any((image) =>
      image.assignLetterCompleted == false);
      if (hasIncomplete) {
        selectedGroupIndex.value = i;
        for (int i = 0; i < soundGroupsController.AllSoundGroupList[selectedGroupIndex.value].imageList.length; i++)
        {
          selectedList.add(soundGroupsController.AllSoundGroupList[selectedGroupIndex.value].imageList[i].imageId);
        }
        updateImgIdsList(selectedList);
        return;
      }
    }
    /// If no incomplete SGImageList is found before the current index
    print('No previous incomplete SGImageList');
  }

  /// Function to fetch Assign Letters List by SoundGrp
  Future<void> fetchSoundGroupAssignLetters(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    try {
      /// Send a GET request to the login API endpoint
      var response = await http.get(
        Uri.parse(URL + '/api/soundGroup/soundGroupGalleryByType?userId=${userId}&soundGroupId=${selectedSoundGrpId.value}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      /// If the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = responseData['data'];
        List<AssignSoundGroupImageData> soundItems = data.map((item) => AssignSoundGroupImageData.fromJson(item)).toList();
        assignSelectedGalleryList.value = soundItems;
        update();
        nextImgHandler();
        // update();
      } else {
        /// Throw an exception to handle the failure
        print(responseData['message']);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error for debugging purposes
      print('Error: $e');
    }
  }

  /// Function to fetch Assign Letters List by SoundGrp
  Future<void> fetchAssignLettersStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    try {
      /// Send a GET request to the API endpoint
      var response = await http.get(
        Uri.parse(URL + '/api/grapheme/graphemeCompletionStatus?userId=${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      /// If the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = responseData['data']['graphemeCompleted'];
        isAssignmentFullyCompleted.value = data;
        update();
      } else {
        /// Throw an exception to handle the failure
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error for debugging purposes
      print('Error: $e');
    }
  }

  /// Skip Image API call
  Future<void> skipImage(BuildContext context, id) async {
    /// Get the user ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// Send a POST request to skip the image
      var response = await http.post(
        Uri.parse(URL + '/api/grapheme/skipImage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"userId": userId, "imageId": id, "skip": true}),
      );
      /// Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// If successful, fetch images and handle next image
        final Map<String, dynamic> json = jsonDecode(response.body);
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

  /// Function To Handle Next Upcoming Images
  void nextImgHandler() {
    /// Check if all images are assigned
    isSGAssignmentCompleted.value = assignSelectedGalleryList.every((element) =>
    element.assignLetterCompleted == true);
    update();
    /// Check if the current image is the last one
    if (selectedImgIndex.value == assignSelectedGalleryList.length - 1) {
      /// Find the index of the next incomplete image
      int nextIncompleteIndex = assignSelectedGalleryList.indexWhere(
          (element) => element.assignLetterCompleted == false, 0);
      /// If there is an incomplete image, move to it
      if (nextIncompleteIndex != -1) {
        selectedImgIndex.value = nextIncompleteIndex;
      } else {
        print('No more incomplete images');
      }
    } else if (assignSelectedGalleryList[selectedImgIndex.value + 1]
            .assignLetterCompleted ==
        false) {
      /// If the next image is incomplete, move to it
      selectedImgIndex.value = selectedImgIndex.value + 1;
      selectedImgIds.value = [assignSelectedGalleryList[selectedImgIndex.value].imageId];
    } else {
      /// Find the index of the next incomplete image after the current one
      int nextIncompleteIndex = assignSelectedGalleryList.indexWhere(
          (element) => element.assignLetterCompleted == false,
          selectedImgIndex.value + 1);
      /// If there is an incomplete image, move to it
      if (nextIncompleteIndex != -1) {
        selectedImgIndex.value = nextIncompleteIndex;
      } else {
        print('No more incomplete images');
      }
    }
  }

  /// Function To Handle Previous Image
  void previousImgHandler() {
    int prevIndex = selectedImgIndex.value - 1;
    while (prevIndex >= 0) {
      if (!assignSelectedGalleryList[prevIndex].assignLetterCompleted) {
        selectedImgIndex.value = prevIndex;
        return;
      }
      prevIndex--;
    }
  }

  String capitalizeFirstWord(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Functions To Set the States of Observables

  void updateLetterTextField(letter) {
    assignLetterTextController.text = letter;
  }

  void updateImgIdsList(list) {
    selectedImgIds.value = list;
    update();
  }

  void updateGroupIndex(index) {
    selectedGroupIndex.value = index;
    update();
  }

  void updateGalleryList(list) {
    assignSelectedGalleryList.value = list;
     update();
  }

  void updateSelectedSoundGrpId(id, url) {
    selectedSoundGrpId.value = id;
    selectedSoundGrpURL.value = url;
    update();
  }

  void updateImgIndex(index) {
    selectedImgIndex.value = index;
    update();
  }

  /// Function to update the state of the submit button
  void updateSubmitButtonState(bool isTextFieldEmpty) {
    isSubmitButtonEnabled.value = !isTextFieldEmpty;
  }
}
