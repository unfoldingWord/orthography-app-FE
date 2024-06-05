import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/letter_group_controller.dart';

class LetterGroupScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LetterGroupsController letterGroupsController = Get.put(LetterGroupsController());
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
            title: AppbarTitle(text: "Letter Groups"),
            actions: [
              SyllableHeaderAction(),
            ],
          ),
          drawer: SidebarComponentScreen(selectedVal: 6),
          body: Stack(
            fit: StackFit.expand,
            children: [
              /// Letter Group List Widget
              Obx(() {
                return SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 19.v),
                    child: Wrap(
                      spacing: 5.h,
                      children: List.generate(
                        letterGroupsController.letterGalleryList.length,
                            (index) {
                          var letter = letterGroupsController.letterGalleryList[index].letter;
                          var imageList = letterGroupsController.letterGalleryList[index].images;
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 18.v, right: 8.v),
                                child: _buildLetterGalleryList(letter, imageList), /// Display letter group
                              ),
                              SizedBox(height: 20.v),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
              /// Video overlay widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                  color: Colors.black.withOpacity(0.5), // Set opacity as needed
                )
                    : Container();
              }),
              /// Video player overlay
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

  /// Widget to build letter gallery list
  Widget _buildLetterGalleryList(String letter, List<dynamic> list) {
    return SizedBox(
      height: 132.v,
      width: 338.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          /// Letter title
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 1.h),
              child: Text(letter, style: theme.textTheme.titleMedium),
            ),
          ),

          /// See more button and image list
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// See more button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.seeMoreLettersGroupsScreen,
                        arguments: {'letter': letter},
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 21.h),
                      child: Text(
                        "lbl_see_more".tr,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 7.v),
                SizedBox(
                  height: 100.v,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 25.h);
                    },
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100.v,
                        width: 90.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.h,
                          vertical: 19.v,
                        ),
                        decoration: AppDecoration.outlineLightblue500.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder5,
                        ),
                        child: CustomImageView(
                          imagePath: list[index].imageObjectUrl,
                          alignment: Alignment.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
