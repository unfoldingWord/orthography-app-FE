import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/widgets/common/app_logo_widget.dart';
import 'package:orthoappflutter/theme/custom_button_style.dart';
import 'package:orthoappflutter/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/languageSelection_controller.dart';
import '../widgets/language_chip_widget.dart';

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// Handle back button press
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs?.getBool('isVideoScreenVisited') == true) {
          Get.offAllNamed(AppRoutes.homepageOneScreen);
        } else {
          Get.back();
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 31.h, vertical: 63.v),
            child: Column(
              children: [
                AppLogo(), /// App logo widget
                SizedBox(height: 12.v),
                Text(
                  'Please select a language',
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff515151),
                  ),
                ),
                SizedBox(height: 37.v),
                LanguageChipWidget(), /// Language selection chips Widget
                SizedBox(height: 82.v),
                _buildGetStartedButton(), /// 'Get Started' button
                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget to build the 'Get Started' button
  Widget _buildGetStartedButton() {
    return CustomElevatedButton(
      text: "msg_let_s_get_started".tr,
      buttonStyle: CustomButtonStyles.fillPrimaryTL25,
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700_1,
      onPressed: () {
        /// Call the method to add base language to user model
        Get.find<LanguageController>().addBaseLangToUserModel();
      },
    );
  }
}

