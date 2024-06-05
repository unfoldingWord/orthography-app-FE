import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/sound_groups_screens/widgets/sound_groups_img_listview.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/sound_groups_controller.dart';

class SoundGroupsGalleryScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomepageController homepageController = HomepageController();
  final SoundGroupsController soundGroupsController = Get.put(SoundGroupsController());

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (controller.isTrainingBtnSelected.value) {
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {
          Get.offAllNamed(AppRoutes.homepageOneScreen);
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leadingWidth: 45.h,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: AppbarTitle(text: "Sound Groups"), /// Title of the app bar
            actions: [
              SyllableHeaderAction() /// Custom action widget for the app bar
            ],
          ),
          drawer: SidebarComponentScreen(selectedVal: 4,), /// Sidebar navigation
          body: Stack(
            fit: StackFit.expand,
            children: [
              SoundGroupImageListview(), /// Widget for displaying sound group images

              /// Video Overlay Widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                  color: Colors.black.withOpacity(0.5), /// Overlay color for video
                )
                    : Container();
              }),

              /// Video Player Widget
              WillPopScope(
                onWillPop: () async {
                  controller.videoPlayerController?.dispose();
                  return true;
                },
                child: GetBuilder<ImageGalleryController>(builder: (controller) {
                  if (controller.isTrainingBtnSelected.value == false) {
                    /// Show loading indicator when training button is not selected
                    return Obx(() {
                      return Center(
                        child: CircularProgressIndicator(
                          color: controller.isTrainingBtnSelected.value == false
                              ? Colors.transparent
                              : Colors.white,
                        ),
                      );
                    });
                  } else {
                    /// Show video player when training button is selected
                    return Chewie(controller: controller.chewieController);
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

