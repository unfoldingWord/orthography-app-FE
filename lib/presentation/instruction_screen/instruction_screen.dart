import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 31.h, vertical: 174.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Orthography Log Image
              SizedBox(
                height: 87.adaptSize,
                width: 87.adaptSize,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    /// Main Orthography Log Image
                    CustomImageView(
                      imagePath: ImageConstant.imgOrthographyLog,
                      height: 87.adaptSize,
                      width: 87.adaptSize,
                      alignment: Alignment.center,
                    ),
                    /// Ellipse Image at the bottom of the Orthography Log
                    CustomImageView(
                      imagePath: ImageConstant.imgEllipse5,
                      height: 1.v,
                      width: 49.h,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 11.v),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 19.v),

              /// Welcome Text
              Text(
                "lbl_welcome".tr,
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(height: 18.v),

              /// Instruction Text
              Container(
                width: 291.h,
                margin: EdgeInsets.only(right: 6.h),
                child: Text(
                  "msg_before_getting_started".tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodyLargeSecondaryContainer.copyWith(
                    height: 1.56,
                  ),
                ),
              ),
              SizedBox(height: 48.v),

              /// Next Button
              CustomElevatedButton(
                text: "lbl_next".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL25,
                buttonTextStyle: CustomTextStyles.titleMediumWhiteA700_1,
                onPressed: () {
                  /// Call the onTapNEXT method
                  onTapNEXT();
                },
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the VideoScreen or HomepageOneScreen based on SharedPreferences value.
  Future<void> onTapNEXT() async {
    /// Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Retrieve the value of 'videosWatched' from SharedPreferences
    bool? videosWatched = prefs.getBool('videosWatched');

    /// Check if videos have been watched
    if (videosWatched == false) {
      /// If videos have not been watched, navigate to the VideoScreen
      Get.offAllNamed(AppRoutes.videoScreen);
    } else {
      /// If videos have been watched, navigate to the HomepageOneScreen
      Get.offAllNamed(AppRoutes.homepageOneScreen);
    }
  }
}
