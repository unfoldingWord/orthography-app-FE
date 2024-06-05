
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/letter_gallery_model.dart';
import 'package:http/http.dart' as http;

class LetterGroupsController extends GetxController {

  final List<String> alphabets = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  final RxInt selectedIndex = (-1).obs;

  final RxList<LetterData> letterGalleryList = <LetterData>[].obs;

  final RxList<SingleLetterImageData> singleLetterGalleryList = <SingleLetterImageData>[].obs;

  /// API URL retrieved from environment variables
  var URL = dotenv.get("API_URL", fallback: "");

  /// Reactive boolean to indicate loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLetterGroups();
  }

  void updateIndex(index) {
    selectedIndex.value=index;
    update();
  }

  /// Method to fetch all letter groups from the API
  Future<void> fetchLetterGroups() async {
    /// Set loading state to true
    isLoading.value = true;
    /// Retrieve user ID from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// Make HTTP GET request
      var response = await http.get(Uri.parse(URL + '/api/grapheme/letterGroupGallery?userId=${userId}'));
      /// Check if request is successful (status code 200)
      if (response.statusCode == 200) {
        /// Parse response body
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> data = responseData['data'];
        if (responseData['message'] == 'No data found') {
          /// Do nothing if no sound groups are found
        } else {
          /// Map response data to list of SoundGroupImage objects
          List<LetterData> letterItems = data.map((item) => LetterData.fromJson(item)).toList();
          /// Update AllSoundGroupList with fetched sound groups
          letterGalleryList.value = letterItems.reversed.toList();
          /// Set loading state to false
          isLoading.value = false;
          /// Update UI
          update();
        }
      } else {
        /// Throw exception if failed to load data
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print error message
      print('Error: $e');
    }
  }

  Future<void> fetchLetterByGroups(letter) async {
    /// Set loading state to true
    isLoading.value = true;
    /// Retrieve user ID from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    try {
      /// Make HTTP GET request
      var response = await http.get(Uri.parse(URL + '/api/grapheme/letterGroupGalleryByType?userId=${userId}&letter=${letter}'));

      /// Check if request is successful (status code 200)
      if (response.statusCode == 200) {
        /// Parse response body
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> data = responseData['data'];
        /// Check if sound groups are found
        if (responseData['message'] == 'No data found') {
          /// Do nothing if no sound groups are found
        } else {
          /// Map response data to list of SingleLetterImageData objects
          List<SingleLetterImageData> letterItems = data.map((item) => SingleLetterImageData.fromJson(item)).toList();
          /// Update Single Letter ImageData with fetched sound groups
          singleLetterGalleryList.value = letterItems.reversed.toList();
          /// Set loading state to false
          isLoading.value = false;
          /// Update UI
          update();
        }
      } else {
        /// Throw exception if failed to load data
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print error message
      print('Error: $e');
    }
  }
}