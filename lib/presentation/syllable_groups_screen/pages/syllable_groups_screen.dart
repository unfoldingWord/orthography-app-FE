import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/widgets/syllable_gallery_list_widget.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/controller/image_gallery_controller.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/syllable_groups_controller.dart';
import 'package:chewie/chewie.dart';

class SyllableGroupsScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SyllableGroupsController syllableGroupsController = Get.put(SyllableGroupsController());

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        /// Handle back button press
        if (controller.isTrainingBtnSelected.value) {
          /// If in training mode, dispose video player and update status
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {
          /// Navigate to the homepage screen
          controller.isEditBtnClicked.value?Get.offAllNamed(AppRoutes.imageGalleryScreen):
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
            // title: AppbarTitle(text: "lbl_syllable_groups".tr),
            title: Obx((){
              return AppbarTitle(text: controller.isEditBtnClicked.value? "Edit Groups": "Syllable Groups");
            }),
            actions: [
              /// Syllable header action widget
              SyllableHeaderAction()
            ],
          ),
          drawer: SidebarComponentScreen(selectedVal: 2,),
          body: Stack(
            fit: StackFit.expand,
            children: [
              /// Syllable group list widget
              SyllableGroupList(),

              /// Video overlay widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                  color: Colors.black.withOpacity(0.5),
                )
                    : Container();
              }),

              /// Video overlay widget
              WillPopScope(
                onWillPop: () async {
                  /// Dispose video player on back press
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
                    /// Chewie video player widget
                    return Chewie(controller: controller.chewieController);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
