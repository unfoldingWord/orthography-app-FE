import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
class FlashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    /// Delay for 2 seconds before executing logic
    Future.delayed(Duration(seconds: 2), () async {
      /// Retrieve SharedPreferences instance
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /// Retrieve stored userId and LangCode, defaulting to empty strings if not found
      String userId = prefs.getString('userId') ?? "";
      String LangCode = prefs.getString('LangCode') ?? "";
      /// Check if userId exists
      if(userId.isNotEmpty)
      {
        /// If LangCode is stored, navigate to the homepage
        if(LangCode.isNotEmpty)
        {
          Get.offAllNamed(AppRoutes.homepageOneScreen);
        }
        /// If LangCode is not stored, navigate to the language selection screen
        else{
          Get.offAllNamed(AppRoutes.languageSelectionScreen);
        }

      }
      /// If userId is not stored, navigate to the login screen
      else{
        Get.offAllNamed(
          AppRoutes.loginScreen,
        );
      }
    });
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0xffFCFCFE), Color(0xff98ABB9)],
              center: Alignment.center,
              stops: [0.2708, 0.8385],
              radius: 0.8,
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: _buildOrthographyLogImage(),
          ),
        ),
      ),
    );
  }

  /// Widget to build Orthography Log Image
  Widget _buildOrthographyLogImage() {
    return SizedBox(
      height: 360.adaptSize,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgOrthographyLog,
            height: 360.adaptSize,
            width: 360.adaptSize,
            alignment: Alignment.center,
          ),

        ],
      ),
    );
  }
}
