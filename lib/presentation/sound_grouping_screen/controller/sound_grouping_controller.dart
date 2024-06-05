import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/controller/expanded_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/singleImg_sound_group_model.dart';
import 'package:http/http.dart' as http;

class SoundGroupingController extends GetxController {
  /// ExpandedViewController Controller
  ExpandedViewController controller = Get.put(ExpandedViewController());

  /// API Base url
  var URL = dotenv.get("API_URL",fallback: "");

  /// Observables for state management
  final RxList<String> options = <String>[""].obs;
  final RxList<SoundGroup> SoundGroupList = <SoundGroup>[].obs;
  final RxList<SoundGroupImageData> SoundGroupImagesList = <SoundGroupImageData>[].obs;
  final RxInt selectedIndex = (-1).obs;
  final RxInt previewImageIndex = (0).obs;

  RxString? draggedImage=''.obs;
  RxInt? seletedIndex=0.obs;
  Rx<Offset> initialDragPosition = Offset.zero.obs;

  RxBool isSoundGrpCompleted = false.obs;
  RxBool isBtnSelected = false.obs;
  RxBool isSoundGrpBtnSelected = false.obs;
  RxBool isMonoCompleted = false.obs;
  RxBool isBiGrpCompleted = false.obs;
  RxString selectedSoundGrpUrl = ''.obs;

  RxBool isTriGrpCompleted = false.obs;
  RxBool isPolyGrpCompleted = false.obs;
  RxBool is20CountCompleted = false.obs;
  RxBool isSubmitBtnEnabled = false.obs;

  RxBool isMonoEnabled = false.obs;
  RxBool isBiGrpEnabled = false.obs;
  RxBool isTriGrpEnabled = false.obs;
  RxBool isPolyGrpEnabled = false.obs;

  /// SharedPreferences
  late SharedPreferences prefs;
  bool _prefsInitialized = false;


  /// Initialize SharedPreferences
  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMonoCompleted', false);
    prefs.setBool('isBiGrpCompleted',false);
    prefs.setBool('isTriGrpCompleted',false);
    prefs.setBool('isPolyGrpCompleted', false);
    fetchSoundGroupsStatus();
    _prefsInitialized = true;
    update();
  }

  bool get isPrefsInitialized => _prefsInitialized;

  @override
  void onInit() {
    super.onInit();
    initSharedPreferences();
    fetchSoundGroupsList();
  }

  void updateIndex(index) {
    selectedIndex.value=index;
    isSubmitBtnEnabled.value=true;
    update();
  }

  void reset() {
    selectedIndex.value=-1;
    SoundGroupImagesList.value=[];
    update();
  }

  void updatePreviewImageIndex(index) {
    previewImageIndex.value=index;
    // update();
  }

  void updateSyllabicStatus(mono,bi,tri,poly) {
    isMonoEnabled.value = mono;
    isBiGrpEnabled.value = bi;
    isTriGrpEnabled.value = tri;
    isPolyGrpEnabled.value = poly;
    // update();
  }

  /// This method to fetch sound groups list status
  Future<void> fetchSoundGroupsList() async {
    /// SharedPreferences instance to get userId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// GET request to fetch sound groups for the user
      var response = await http.get(Uri.parse(URL + '/api/soundGroup/getSoundGroups?userId=${userId}'));

      /// Check if the request is successful (status code 200)
      if (response.statusCode == 200) {
        /// Decode the response body to a Map
        Map<String, dynamic> responseData = json.decode(response.body);

        /// Extract data from the response
        List<dynamic> data = responseData['data'];

        /// Check if any sound groups are found
        if (responseData['message'] == 'No sound groups found') {
          /// Do nothing if no sound groups are found
        } else {
          /// Create a list of SoundGroup objects from the data
          List<SoundGroup> soundItems = data.map((item) => SoundGroup.fromJson(item)).toList();

          /// Update the SoundGroupList with the new list of sound groups
          SoundGroupList.value = soundItems.reversed.toList();
          update();
        }
      } else {
        /// If the response status code is not 200, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error if any occurs
      print('Error: $e');
    }
  }

  /// This method to fetch sound group status
  Future<void> fetchSoundGroupsStatus() async {
    /// SharedPreferences instance to get userId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// GET request to fetch completion status for sound groups
      var response = await http.get(Uri.parse(URL + '/api/soundGroup/getCompletionStatusForSoundGroup?userId=${userId}'));

      /// Check if the request is successful (status code 200)
      if (response.statusCode == 200) {
        /// Decode the response body to a Map
        Map<String, dynamic> responseData = json.decode(response.body);

        /// Set completion status for various sound group types in SharedPreferences
        prefs.setBool('isMonoCompleted', responseData['data']['mono']);
        prefs.setBool('isBiGrpCompleted', responseData['data']['bi']);
        prefs.setBool('isTriGrpCompleted', responseData['data']['tri']);
        prefs.setBool('isPolyGrpCompleted', responseData['data']['poly']);

        /// Update observables based on the response data
        isSoundGrpCompleted.value = responseData['data']['soundGroupingCompleted'];
        is20CountCompleted.value = responseData['data']['count20CheckCompleted'];
        update();
      } else {
        /// If the response status code is not 200, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error if any occurs
      print('Error: $e');
    }
  }

  /// This method to fetch images based on sound group
  Future<void> fetchSoundGroupsImages(id, imgId, imgUrl, languageId, userId, pre_id) async {
    /// SharedPreferences instance to get userId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// GET request to fetch sound group images by type
      var response = await http.get(Uri.parse(URL + '/api/soundGroup/soundGroupGalleryByType?userId=${userId}&soundGroupId=${id}'));

      /// Decode the response body to a Map
      Map<String, dynamic> responseData = json.decode(response.body);

      /// Check if the request is successful (status code 200)
      if (response.statusCode == 200) {
        /// Extract data from the response
        List<dynamic> data = responseData['data'];

        /// Check if there are sound groups found
        if (responseData['message'] == 'No sound groups found') {
          /// Do nothing if no sound groups are found
        } else {
          /// Create a list of SoundGroupImageData objects from the data
          List<SoundGroupImageData> soundGroupImagesItems = data.map((item) => SoundGroupImageData.fromJson(item)).toList();

          /// Create a new SoundGroupImageData object to append to the list
          var appendImg = SoundGroupImageData(
            id: id,
            imageId: imgId,
            imageObjectUrl: imgUrl,
            languageId: languageId,
            userId: userId,
          );

          /// Update the list of sound group images with the new image appended
          List<SoundGroupImageData> updatedList = [...soundGroupImagesItems, appendImg];
          SoundGroupImagesList.value = updatedList.reversed.toList(); // Assign the updated list to SoundGroupImagesList.value
          update();
        }
      } else {
        /// If the response status code is not 200, handle the error
        /// Create a new SoundGroupImageData object to add to the list
        var appendImg = SoundGroupImageData(
          id: id,
          imageId: imgId,
          imageObjectUrl: imgUrl,
          languageId: languageId,
          userId: userId,
        );
        SoundGroupImagesList.add(appendImg);

        /// Throw an exception indicating failed to load data
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error if any occurs
      print('Error: $e');
    }
  }

  /// This method to create sound group using API
  Future<void> createSoundGroupUpdate(imageId, BuildContext context) async {
    /// Clear SoundGroupImagesList and trigger update
    SoundGroupImagesList.value = [];
    update();

    /// SharedPreferences instance to get userId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// POST request to create a new sound group
      var response = await http.post(
        Uri.parse(URL + '/api/soundGroup/createSoundGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": userId,
          "imageId": imageId,
        }),
      );

      /// Decode the response body to a Map
      final Map<String, dynamic> json = jsonDecode(response.body);

      /// Check if the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Fetch the updated sound groups list and handle completion
        fetchSoundGroupsList().whenComplete(() {
          // selectedIndex.value = 0;
          // update();
          updateIndex(1);
        });


      } else {
        /// Show a SnackBar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );
        /// Will Remove the SnackBar after 2 seconds
        Timer(Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        /// Throw an exception indicating failed to load data
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error if any occurs
      print('Error: $e');
    }
  }

  /// This method skips an image in the sound group
  Future<void> skipImage(BuildContext context, id) async {
    /// SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /// Retrieve the userId from SharedPreferences
    var userId = prefs.getString('userId');

    try {
      /// POST request to skip the sound group image
      var response = await http.post(
        Uri.parse(URL + '/api/soundGroup/skipSoundGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": userId,
          "imageId": id,
          "skip": true,
        }),
      );

      /// Check if the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Decode the response body to a Map
        final Map<String, dynamic> json = jsonDecode(response.body);
        /// Fetch syllables type and handle the next image in the sound group
        controller.fetchSyllablesType(controller.syllableType).whenComplete(() => soundGroupNextImgHandler());
      } else {
        /// Decode the response body to a Map
        final Map<String, dynamic> json = jsonDecode(response.body);
        /// Show a SnackBar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );
        /// Will Remove the SnackBar after 2 seconds
        Timer(Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        /// Throw an exception indicating failed to load data
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error if any occurs
      print('Error: $e');
    }
  }

  /// This method updates the group status
  void updateGrpStatus(){
    isSoundGrpCompleted.value=false;
    isMonoCompleted.value=false;
    isBiGrpCompleted.value=false;
    isTriGrpCompleted.value=false;
    isPolyGrpCompleted.value=false;
    is20CountCompleted.value=false;
    // update();
  }

  /// This method updates the dialog status
  void updateDailogStatus(){
    isSoundGrpCompleted.value=false;
    isMonoCompleted.value=false;
    isBiGrpCompleted.value=false;
    isTriGrpCompleted.value=false;
    isPolyGrpCompleted.value=false;
  }

  /// Method to handle the next image in the sound group
  void soundGroupNextImgHandler() {
    /// Fetch sound group status and update completion status based on syllable type
    fetchSoundGroupsStatus().whenComplete(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /// Check if all sound group images are completed
      var result = controller.syllabiclistItemList.every((element) {
        return element.soundGroupingCompleted == true;
      });
      /// If all sound group images are completed
      if (isSoundGrpCompleted.value == true) {
        /// Reset all completion flags and update
        isMonoCompleted.value = false;
        isBiGrpCompleted.value = false;
        isTriGrpCompleted.value = false;
        isPolyGrpCompleted.value = false;
        update();
      }
      /// If 20 count completion flag is true
      else if (is20CountCompleted.value == true) {
        /// Reset all completion flags and update
        isSoundGrpCompleted.value = false;
        isMonoCompleted.value = false;
        isBiGrpCompleted.value = false;
        isTriGrpCompleted.value = false;
        isPolyGrpCompleted.value = false;
        update();
      }
      /// Check syllable type and update completion flag accordingly
      else if (controller.syllableType == 1 && isSoundGrpCompleted.value == false) {
        isMonoCompleted.value = result;
        prefs.setBool('isMonoCompleted', result);
        update();
      } else if (controller.syllableType == 2 && isSoundGrpCompleted.value == false) {
        isBiGrpCompleted.value = result;
        prefs.setBool('isBiGrpCompleted', result);
        update();
      } else if (controller.syllableType == 3 && isSoundGrpCompleted.value == false) {
        isTriGrpCompleted.value = result;
        prefs.setBool('isTriGrpCompleted', result);
        update();
      } else if (controller.syllableType == 4 && isSoundGrpCompleted.value == false) {
        isPolyGrpCompleted.value = result;
        prefs.setBool('isPolyGrpCompleted', result);
        update();
      }
    });

    /// Handling the selection of the next image
    if (controller.selectedImgIndex.value == controller.syllabiclistItemList.length - 1) {
      /// If on the last image, check for pending images and move to the first pending one
      int nextIncompleteIndex = controller.syllabiclistItemList.indexWhere(
              (element) => element.soundGroupingCompleted == false,0);
      if (nextIncompleteIndex != -1) {
        controller.selectedImgIndex.value = nextIncompleteIndex;
      } else {
        /// If there are no more incomplete images, loop back to the beginning
        nextIncompleteIndex = controller.syllabiclistItemList.indexWhere(
                (element) => element.soundGroupingCompleted == false,0);
        if (nextIncompleteIndex != -1) {
          controller.selectedImgIndex.value = nextIncompleteIndex;
        } else {
          /// Handled case when all images are completed
          print('All images are completed');
        }
      }
    } else if (controller.syllabiclistItemList[controller.selectedImgIndex.value + 1].soundGroupingCompleted == false) {
      /// If the next image is incomplete, move to the next one
      controller.selectedImgIndex.value = controller.selectedImgIndex.value + 1;
    } else {
      /// Find the next incomplete image after the current index
      int nextIncompleteIndex = controller.syllabiclistItemList.indexWhere(
            (element) => element.soundGroupingCompleted == false,
        controller.selectedImgIndex.value + 1,
      );

      if (nextIncompleteIndex == -1) {
        /// If no incomplete image is found after the current index, loop back to the beginning
        nextIncompleteIndex = controller.syllabiclistItemList.indexWhere(
                (element) => element.soundGroupingCompleted == false, 0);
      }

      if (nextIncompleteIndex != -1) {
        controller.selectedImgIndex.value = nextIncompleteIndex;
      } else {
        /// Handle case when all images are completed
        print('All images are completed');
      }
    }
  }

  /// Method to handle the previous image in the sound group
  void soundGroupPreviousImgHandler() {
    int prevIndex = controller.selectedImgIndex.value - 1;
    print('syllabiclistItemList ${controller.syllabiclistItemList[prevIndex].soundGroupingCompleted}');
    while (prevIndex >= 0) {
      if (!controller.syllabiclistItemList[prevIndex].soundGroupingCompleted) {
        controller.selectedImgIndex.value = prevIndex;
        return;
      }
      prevIndex--;
    }

  }

  /// This method assigns a sound group to an image
  Future<void> assignSoundGroup(imageId,soundGroupId,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId=prefs.getString('userId');

    try {
      var response = await http.post(Uri.parse(URL+'/api/soundGroup/assignSoundGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId":userId,
          "imageId":imageId,
          "soundGroupId" : soundGroupId
        }),
      );
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        controller.fetchSyllablesType(controller.syllableType).whenComplete(() => soundGroupNextImgHandler());
        fetchSoundGroupsList();
        SoundGroupImagesList.value=[];
        selectedIndex.value=-1;
        update();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );
        Timer(Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Custom toast function
  static void showCustomToast(String message, BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black87,
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }

  /// This method updates images to one sound group to another
  Future<void> updateSoundGroup(imageId, soundGroupId, BuildContext context) async {
    /// SharedPreferences instance to get userId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// POST request to assign a sound group to an image
      var response = await http.post(
        Uri.parse(URL + '/api/soundGroup/assignSoundGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": userId,
          "imageId": imageId,
          "soundGroupId": soundGroupId
        }),
      );

      /// Decode the response body to a Map
      final Map<String, dynamic> json = jsonDecode(response.body);

      /// Check if the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Navigate to the sound grouping screen
        Get.offAllNamed(AppRoutes.soundGroupingScreen);
      } else {
        /// Show a custom toast with the error message
        showCustomToast(json['message'], context);
        /// Throw an exception indicating failed to load data
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error if any occurs
      print('Error: $e');
    }
  }

  void updateSelectedIndex(int index,imgId,imgUrl,languageId,userId,id) {
    selectedIndex.value = index;
    SoundGroupImagesList.value=[];
    fetchSoundGroupsImages(SoundGroupList[selectedIndex.value].soundGroupId,imgId,imgUrl,languageId,userId,id);
    update();
  }

  Future<void> createSoundGroup(imageId,imgUrl,languageId,userId,id,BuildContext context) async {
    SoundGroupImagesList.value=[];
    update();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId=prefs.getString('userId');
    try {
      var response = await http.post(Uri.parse(URL+'/api/soundGroup/createSoundGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId":userId,
          "imageId":imageId,
        }),
      );
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchSoundGroupsList().whenComplete((){
          selectedIndex.value=0;
          update();
          fetchSoundGroupsImages(SoundGroupList[0].soundGroupId,imageId,imgUrl,languageId,userId,id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );
        Timer(Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }

  }

  @override
  void onClose() {
    super.onClose();
  }

}
