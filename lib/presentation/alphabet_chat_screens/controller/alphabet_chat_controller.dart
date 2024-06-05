import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_export.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class AlphabetChartController extends GetxController {
  RxBool isLoading = false.obs;

  /// URL for API calls retrieved from environment variables
  var URL = dotenv.get("API_URL", fallback: "");

  Future<void> fetchExportLink(BuildContext context) async {
    /// Set isLoading to true to indicate that data is being loaded
    isLoading.value = true;

    /// Get the user ID and from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    try {
      /// Send a GET request to fetch image gallery data
      var response = await http.get(
          Uri.parse(URL + '/api/alphabetChart/downloadPDF?userId=${userId}'));

      /// Decode the response body into a map
      Map<String, dynamic> responseData = json.decode(response.body);

      /// Check if the request was successful
      if (response.statusCode == 200) {
        var downloadUrl = responseData['data'];
        downloadPdf(downloadUrl);
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
      print('Error: $e');
    }
  }

  Future<void> downloadPdf(url) async {
    FileDownloader.downloadFile(
        url: url,
        name: "Alphabet Chart",
        onProgress: (String? fileName, double progress) {
          isLoading.value = true;
          print('FILE fileName HAS PROGRESS $progress');
        },
        onDownloadCompleted: (String path) {
          isLoading.value = false;
          print('FILE DOWNLOADED TO PATH: $path');
        },
        onDownloadError: (String error) {
          isLoading.value = false;
          print('DOWNLOAD ERROR: $error');
        });
  }
}
