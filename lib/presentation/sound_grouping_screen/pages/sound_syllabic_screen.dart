
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/sidebar_component_screen/sidebar_component_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../syllable_groups_screen/controller/expanded_view_controller.dart';
import '../controller/sound_grouping_controller.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';

class SoundSyllabicScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController()); /// Initializing controllers and keys
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpandedViewController expandedViewController = Get.put(ExpandedViewController());
  final SoundGroupingController soundGroupingController = Get.put(SoundGroupingController());
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    expandedViewController.updateSyllableType(arguments['number']); /// Update syllable type and group status
    soundGroupingController.updateGrpStatus();
    soundGroupingController.fetchSoundGroupsStatus();
    return WillPopScope(
      /// WillPopScope for handling back button press
      onWillPop: () async {
        if (controller.isTrainingBtnSelected.value) {
          /// Dispose video controller if training is selected
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {
          Get.back(); /// Navigate back to previous screen
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
            title: AppbarTitle(text: '${arguments['syllableType']} Syllabic Group'),
            actions: [SyllableHeaderAction()],
          ),
          drawer: SidebarComponentScreen(selectedVal: 2), /// Drawer for displaying sidebar menu
          /// Obx for reactive UI updates
          body: Obx(() {
            /// Skeletonizer for displaying loading skeleton
            return Skeletonizer(
              enabled: controller.isLoading.value,
              child: Stack(
                /// Stack for stacking widgets on top of each other
                fit: StackFit.expand,
                children: [
                  SizedBox(
                    child: SingleChildScrollView(
                      /// SingleChildScrollView for scrolling content
                      padding: EdgeInsets.only(top: 14.v),
                      child: _buildSyllabicList(), /// Build syllabic list widget
                    ),
                  ),
                  Obx(() {
                    /// Obx for observing training button selection
                    return controller.isTrainingBtnSelected.value == true /// Overlay for video training
                        ? Container(
                      color: Colors.black.withOpacity(0.5),
                    )
                        : Container();
                  }),
                  WillPopScope(
                    /// WillPopScope for handling back button press during video playback
                    onWillPop: () async {
                      controller.videoPlayerController?.dispose();
                      return true;
                    },
                    child: GetBuilder<ImageGalleryController>( // GetBuilder for updating UI based on controller changes
                      builder: (controller) {
                        if (controller.isTrainingBtnSelected.value == false) {
                          return Obx(() {
                            /// Display loading indicator if training is not selected
                            return Center(
                              child: CircularProgressIndicator(
                                color: controller.isTrainingBtnSelected.value == false
                                    ? Colors.transparent
                                    : Colors.white,
                              ),
                            );
                          });
                        } else {
                          return (controller.chewieController != null) /// Display video player if available
                              ? Chewie(controller: controller.chewieController!)
                              : Container(); /// fallback widget
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSyllabicList() {
    /// Widget method for building syllabic list
    return GetBuilder<ExpandedViewController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 0.h),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 101.v,
              crossAxisCount: 3,
              mainAxisSpacing: 23.h,
              crossAxisSpacing: 23.h,
            ),
            physics: NeverScrollableScrollPhysics(), /// Disable scrolling in GridView
            itemCount: controller.syllabiclistItemList.length,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Colors.grey,
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Future.delayed(Duration(milliseconds: 200), () {
                    if (!controller.syllabiclistItemList[index].soundGroupingCompleted) {
                      controller.selectedImgIndex.value = index;
                      Get.toNamed(AppRoutes.assignSoundGroupScreen, arguments: {
                        'syllableType': arguments['syllableType'],
                        'number': 1,
                      });
                    }
                  });
                },
                child: Container(
                  height: 100.v,
                  width: 190.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 9.v),
                  decoration: AppDecoration.outlineLightblue500.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: controller.syllabiclistItemList[index].soundGroupingCompleted == true /// Check if syllabic grouping is completed
                      ? Stack(
                    /// Stack for overlaying completion checkmark
                    children: [
                      Positioned(
                        /// Positioned widget for placing checkmark icon
                        top: 0,
                        right: 0,
                        child: CustomImageView(
                          /// CustomImageView for displaying checkmark icon
                          imagePath: ImageConstant.imgCheckmark,
                          alignment: Alignment.topRight,
                          height: 20.h,
                          width: 20.v,
                        ),
                      ),
                      Positioned(
                        /// Positioned widget for placing syllabic image
                        top: 20,
                        left: 10,
                        child: CustomImageView(
                          /// CustomImageView for displaying syllabic image
                          imagePath: controller.syllabiclistItemList[index].imageObjectUrl,
                          alignment: Alignment.center,
                          height: 60.adaptSize,
                          width: 60.adaptSize,
                        ),
                      ),
                    ],
                  )
                      : SizedBox(
                        height: 58.h,
                        width: 59.v,
                        child: CustomImageView(
                          /// CustomImageView for displaying syllabic image
                          imagePath: controller.syllabiclistItemList[index].imageObjectUrl,
                          alignment: Alignment.center,
                        ),
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
