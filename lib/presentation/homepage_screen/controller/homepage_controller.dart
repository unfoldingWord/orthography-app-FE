import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';

class HomepageController extends GetxController {
  final ImageGalleryController controller = ImageGalleryController();
  RxBool isLoading = false.obs;
  SharedPreferences? prefs;
  String URL = dotenv.get("API_URL", fallback: "");

  /// List of modules on the homepage with initial values
  RxList HomePageCompList = [
    {
      'icon': ImageConstant.imgTelevision,
      'title': 'Identify Syllables',
      'onTap': AppRoutes.imageGalleryScreen,
      'isOpen': true,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0,
      'skippedImages':0
    },
    {
      'icon': ImageConstant.imgHeroiconsrectanglegroup20solid,
      'title': 'Syllable Groups',
      'onTap': AppRoutes.syllableGroupsScreen,
      'isOpen': false,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0,
      'skippedImages':0
    },
    {
      'icon': ImageConstant.imgTeenyiconssoundonsolidPrimarycontainer,
      'title': 'Sound Grouping',
      'onTap': AppRoutes.soundGroupGalleryScreen,
      'isOpen': false,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0,
      'skippedImages':0
    },
    {
      'icon': ImageConstant.imgFluentgrouplist24filled,
      'title': 'Sound Groups',
      'onTap': AppRoutes.soundGroupingScreen,
      'isOpen': false,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0,
      'skippedImages':0
    },

    {
      'icon': ImageConstant.letterGroups,
      'title': 'Assign Letters',
      'onTap': AppRoutes.letterAssignmentGallery,
      'isOpen': false,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0,
      'skippedImages':0
    },

    {
      'icon': ImageConstant.imgSettings,
      'title': 'Letter Groups',
      'onTap': AppRoutes.letterGroupsScreen,
      'isOpen': false,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0.0,
      'skippedImages':0
    },
    {
      'icon': ImageConstant.imgGroup,
      'title': 'Alphabet Chart',
      'onTap': AppRoutes.alphabetChatScreen,
      'isOpen': false,
      'totalImages':0,
      'completedImages':0,
      'incompletedImages':0,
      'percentageComplete':0.0,
      'skippedImages':0
    },
  ].obs;

  /// List of modules on the sidebar with initial values
  RxList SidebarCompList = [
    {
      'title': 'Home',
      'onTap': AppRoutes.homepageOneScreen,
      'sidebaricon': ImageConstant.imgdashicon,
      'isOpen': true
    },
    {
      'title': 'Identify Syllables',
      'onTap': AppRoutes.imageGalleryScreen,
      'sidebaricon': ImageConstant.imgMaterialsymbolsdashboardPrimarycontainer,
      'isOpen': true
    },
    {
      'title': 'Syllable Groups',
      'onTap': AppRoutes.syllableGroupsScreen,
      'sidebaricon': ImageConstant.imgUpload,
      'isOpen': false
    },
    {
      'title': 'Sound Grouping',
      'onTap': AppRoutes.soundGroupGalleryScreen,
      'sidebaricon': ImageConstant.imgTeenyiconssoundonsolidPrimarycontainer,
      'isOpen': false
    },
    {
      'title': 'Sound Groups',
      'onTap': AppRoutes.soundGroupingScreen,
      'sidebaricon': ImageConstant.imgFluentgrouplist24filled,
      'isOpen': false
    },

    {
      'sidebaricon': ImageConstant.letterGroups,
      'title': 'Assign Letters',
      'onTap': AppRoutes.letterAssignmentGallery,
      'isOpen': false
    },

    {
      'sidebaricon': ImageConstant.imgSettings,
      'title': 'Letter Groups',
      'onTap': AppRoutes.letterGroupsScreen,
      'isOpen': false
    },
    {
      'title': 'Alphabet Chart',
      'onTap': AppRoutes.alphabetChatScreen,
      'sidebaricon': ImageConstant.imgUser,
      'isOpen': false
    },
    {
      'title': 'Getting started Videos',
      'onTap': AppRoutes.videoScreen,
      'sidebaricon': ImageConstant.imgSettingsPrimarycontainer15x15,
      'isOpen': true
    },
    {
      'title': 'Choose Base Language',
      'onTap': AppRoutes.languageSelectionScreen,
      'sidebaricon': ImageConstant.imgMaterialsymbolslanguage,
      'isOpen': true
    },
  ].obs;


  @override
  void onInit() {
    super.onInit();
    initSharedPreferences();
    fetchStatus(Get.context!);
  }

  /// Initialize SharedPreferences
  Future<void> initSharedPreferences() async {
    try {
      prefs = await SharedPreferences.getInstance();
      prefs?.setBool('isVideoScreenVisited', true);
      prefs?.setBool('isLangScreenVisited', true);
      // prefs?.setBool('btnClicked', false);
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
    }
  }

  /// Fetch the status of module completion
  Future<void> fetchStatus(BuildContext context) async {
    /// Set isLoading to true to indicate that data is being fetched
    isLoading.value = true;

    /// Retrieve userId from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    try {
      /// GET request to fetch progress data from the server
      var response = await http.get(
        Uri.parse(URL + '/api/progress/getProgressAll?userId=$userId&code=EN'),
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        /// Parse response data
        List<dynamic> dataList = responseData['data'];

        /// Update values for each module in the homepage and sidebar component lists
        for (var item in dataList) {
          String module = item['module'];
          bool isOpen = item['isOpen'];

          /// Update values in the homepage component list
          for (var i = 0; i < HomePageCompList.length; i++) {
            if (module == HomePageCompList[i]['title']) {
              HomePageCompList[i]['isOpen'] = item['isOpen'];
              HomePageCompList[i]['totalImages'] = item['TotalImages'];
              HomePageCompList[i]['completedImages'] = item['CompletedImages'];
              HomePageCompList[i]['incompletedImages'] = item['IncompletedImages'];
              HomePageCompList[i]['percentageComplete'] = item['PercentageComplete'];
              HomePageCompList[i]['skippedImages'] = item['SkippedImages'];
            }
          }

          /// Update values in the sidebar component list
          for (var j = 0; j < SidebarCompList.length; j++) {
            if (module == SidebarCompList[j]['title']) {
              SidebarCompList[j]['isOpen'] = item['isOpen'];
            }
          }
        }
        /// Notify listeners of the change in data
        update();

        /// Set isLoading to false as data fetching is complete
        isLoading.value = false;
      } else {
        /// Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
        Timer(Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      /// Handle exceptions
      print('Error: $e');
    }
  }

}
