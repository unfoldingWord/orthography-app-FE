import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/all_sound_model.dart';

class SoundGroupsController extends GetxController {
  /// Reactive list to hold sound group images
  final RxList<SoundGroupImage> AllSoundGroupList = <SoundGroupImage>[].obs;

  /// Observable list for selected image id's
  RxList selectedImgIds = RxList([].obs);
  /// API URL retrieved from environment variables
  var URL = dotenv.get("API_URL", fallback: "");

  /// Reactive boolean to indicate loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    /// Fetch sound groups when controller is initialized
    fetchAllSoundGroups();
  }

  /// Method to fetch all sound groups from the API
  Future<void> fetchAllSoundGroups() async {
    /// Set loading state to true
    isLoading.value = true;

    /// Retrieve user ID from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// Make HTTP GET request to fetch sound groups
      var response = await http.get(Uri.parse(URL + '/api/soundGroup/soundGroupGallery?userId=${userId}'));

      /// Check if request is successful (status code 200)
      if (response.statusCode == 200) {
        // Parse response body
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> data = responseData['data'];

        /// Check if sound groups are found
        if (responseData['message'] == 'No sound groups found') {
          /// Do nothing if no sound groups are found
        } else {
          /// Map response data to list of SoundGroupImage objects
          List<SoundGroupImage> soundItems = data.map((item) => SoundGroupImage.fromJson(item)).toList();
          /// Update AllSoundGroupList with fetched sound groups
          AllSoundGroupList.value = soundItems.reversed.toList();
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
