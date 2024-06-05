import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chewie/chewie.dart';
import '../controller/video_controller.dart';
import '../widegts/video_screen_widgets.dart';

class VideoScreen extends StatelessWidget {
  final VideoController controller = Get.put(VideoController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// Used WillPopScope for handling back button press.
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs?.getBool('isVideoScreenVisited') == true) {
          Get.offAllNamed(AppRoutes.homepageOneScreen);
        } else {
          prefs?.setBool('isVideoScreenVisited', true);
          prefs?.setBool('isLangScreenVisited', true);
          Get.back();
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: GetBuilder<VideoController>(
                builder: (controller) {
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 206.h,
                              width: double.maxFinite,
                              child: controller.isVideoInitialized.value
                                  ? Chewie(
                                controller: controller.chewieController!,
                              )
                                  : Center(
                                child: CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.v),
                            buildVideoList(), /// Extracted method for video list widget.
                          ],
                        ),
                      ),
                      buildOption(), /// Extracted method for don't show option widget.
                      SizedBox(height: 17.v),
                      buildStartButton(), /// Extracted method for start button widget.
                      SizedBox(height: 5.v),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
