import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/languageSelection_model.dart';

class LanguageController extends GetxController {
  /// Observable list for storing language models
  RxList<LanguageModel> langList = <LanguageModel>[].obs;

  /// Observable variable for storing the index of the selected language
  RxInt selectedIndex = 0.obs;

  /// Observable variable for storing the code of the selected language
  RxString selectedLangCode = ''.obs;

  /// Observable variable for storing the code of the selected spoken language
  RxString selectedSpokenLangCode = ''.obs;

  /// API URL retrieved from environment variables
  String URL = dotenv.get("API_URL", fallback: "");

  @override
  void onInit() {
    super.onInit();
    fetchLanguage(Get.context!);
  }

  /// Fetches the base language data from the API
  Future<void> fetchLanguage(BuildContext context) async {
    /// Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      /// Send a GET request to fetch base language data
      var response = await http.get(Uri.parse(URL + '/api/language/base'));
      final Map<String, dynamic> json = jsonDecode(response.body);

      /// Check if the request was successful
      if (response.statusCode == 200) {
        /// Convert data from JSON to a list of LanguageModel objects
        List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(json['data']);
        List<LanguageModel> languageModels =
        data.map((item) => LanguageModel.fromJson(item)).toList();

        prefs.setString('LangCode', 'EN');
        langList.value = languageModels;
      } else {
        /// If the request was not successful, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );
        /// Will Remove the error message after 2 seconds
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

  /// Adds the selected base language to the user model via API
  Future<void> addBaseLangToUserModel() async {
    /// Obtain SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Retrieve the selected language code from SharedPreferences
    var code = prefs.getString('LangCode');

    try {
      /// Send a POST request to add the base language for the user
      var response = await http.post(
        Uri.parse(URL + '/api/language/addBaseLanguageForUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": prefs.getString('userId'),
          "code": code
        }),
      );

      /// Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// If successful, navigate to the instruction screen
        Get.offAllNamed(AppRoutes.instructionScreen);
      } else {
        /// If the request was not successful, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  /// Save Selected Language Code Function
  Future<void> saveLangCode(code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LangCode', code);
  }

  /// Update states
  void updateValue(int index, bool value) {
    if (value) {
      langList.forEach((item) {
        item.isSelected = false;
      });
      langList[index].isSelected = true;
      selectedLangCode.value = langList[index].id;
    }
    update();
  }
}
