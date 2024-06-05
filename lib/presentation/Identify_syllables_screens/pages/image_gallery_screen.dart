import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_image_gallery_list.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/homepage_screen/controller/homepage_controller.dart';
import 'package:orthoappflutter/presentation/sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/image_gallery_controller.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';

class ImageGalleryScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomepageController homepageController = HomepageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isTrainingBtnSelected.value) {
          /// If training video is selected, dispose the video player and prevent route pop
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {
          /// If training video is not selected, navigate back to the homepage
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
            title: AppbarTitle(text: "Syllable Group Gallery"), /// Appbar title
            actions: [SyllableHeaderAction()], /// Header actions for syllable
          ),
          drawer: SidebarComponentScreen(selectedVal: 1), /// Sidebar drawer
          body: Stack(
            fit: StackFit.expand,
            children: [
              /// Image Gallery List Widget
              ImageGalleryList(),

              /// Video Overlay Widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(color: Colors.black.withOpacity(0.5))
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
                    return OrientationBuilder(
                      builder: (context, orientation) {
                        return Chewie(
                          key: Key(controller.videoPlayerController.hashCode.toString()),
                          controller: controller.chewieController,
                        );
                      },
                    );
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
