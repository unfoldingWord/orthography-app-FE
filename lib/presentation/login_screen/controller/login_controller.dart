import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  /// Controller for the phone number text field
  TextEditingController phoneNumberController = TextEditingController();

  RxBool isLoginButtonEnabled = false.obs; /// Indicates if data is loading

  /// Observable for the selected country phone code
  RxString selectedCountry = '91'.obs;

  /// Base URL for API calls, fetched from environment variables
  var URL = dotenv.get("API_URL", fallback: "");

  /// Function to update the selected country phone code
  void updateCode(val) {
    selectedCountry.value = val;
    update(); /// Notify listeners about the change
  }

  void updateEnableBtn() {
    isLoginButtonEnabled.value = true;
    update(); /// Notify listeners about the change
  }

  void updateDisableBtn() {
    isLoginButtonEnabled.value = false;
    update(); /// Notify listeners about the change
  }

  /// Function to handle the login process
  Future<void> handleLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      /// Send a POST request to the login API endpoint
      var response = await http.post(
        Uri.parse(URL + '/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "phoneNumber": phoneNumberController.text,
          "phoneCode": '+${selectedCountry.value}'
        }),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);

      /// If the request is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Extract user data from the response
        var userId = json['data']['_id'];
        var videosWatched = json['data']['videosWatched'];

        /// Save user data to SharedPreferences
        prefs.setString('userId', userId);
        prefs.setBool('videosWatched', videosWatched);
        prefs.setBool('isVideoScreenVisited', false);
        prefs?.setBool('isLangScreenVisited', false);

        /// Navigate to the language selection screen
        Get.offAllNamed(AppRoutes.languageSelectionScreen);
      } else {
        /// If the request fails, show a SnackBar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']),
          ),
        );

        /// Will Remove the SnackBar after 2 seconds
        Timer(Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });

        /// Throw an exception to handle the failure
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Print the error for debugging purposes
      print('Error: $e');
    }
  }
}
