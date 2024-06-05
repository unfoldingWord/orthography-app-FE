import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import '../controller/expanded_view_controller.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';

class SyllabicExpandedViewScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomepageController homepageController = HomepageController();
  final ExpandedViewController expandedViewController = ExpandedViewController();
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    expandedViewController.updateSyllableType(arguments['number']);
    mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (controller.isTrainingBtnSelected.value) {
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {
          Get.offAllNamed(AppRoutes.syllableGroupsScreen);
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
              title: AppbarTitle(
                  text: '${arguments['syllableType']} Syllable Group'
              ),
              actions: [
                SyllableHeaderAction()
              ]
          ),
          drawer: SidebarComponentScreen(selectedVal: 2),
          body: Obx(() {
            return Skeletonizer(
              enabled: controller.isLoading.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 21.v),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.v),
                        child: Column(
                          children: [
                            _buildImagePreview(),
                            SizedBox(height: 15.v),
                            _buildRiArrowUpLine(),
                            SizedBox(height: 40.v),
                            GetBuilder<ExpandedViewController>(
                              builder: (controller) {
                                return GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 101.v,
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 19.h,
                                        crossAxisSpacing: 1.h
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.syllabiclistItemList.length,
                                    itemBuilder: (context, index) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 15.h, right: 15.h),
                                          child: GetBuilder<ExpandedViewController>(
                                            builder: (controller) {
                                              return InkWell(
                                                splashColor: Colors.grey,
                                                onTap: () {
                                                  controller.updateIndex(index);
                                                },
                                                child: Container(
                                                  height: 100.v,
                                                  width: 90.h,
                                                  padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 20.v),
                                                  decoration: AppDecoration.outlineLightblue500.copyWith(
                                                    borderRadius: BorderRadiusStyle.roundedBorder5,
                                                  ),
                                                  child: CustomImageView(
                                                    imagePath: controller.syllabiclistItemList[index].imageObjectUrl,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /// Video Overlay Widget
                  Obx(() {
                    return controller.isTrainingBtnSelected.value == true
                        ? Container(
                      color: Colors.black.withOpacity(0.5), // Set opacity as needed
                    )
                        : Container();
                  }),
                  /// Video Overlay Widget
                  WillPopScope(
                    onWillPop: () async {
                      controller.videoPlayerController?.dispose();
                      return true;
                    },
                    child: GetBuilder<ImageGalleryController>(
                      builder: (controller) {
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
                          return (controller.chewieController != null)
                              ? Chewie(controller: controller.chewieController!)
                              : Container(); /// fallback widget
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Section Widget: Image Preview
  Widget _buildImagePreview() {
    return GetBuilder<ExpandedViewController>(
      builder: (controller) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              /// Swipe to the right
              if (controller.selectedImgIndex.value != 0) {
                controller.selectedImgIndex.value =
                    controller.selectedImgIndex.value - 1;
              }
            } else if (details.primaryVelocity! < 0) {
              /// Swipe to the left
              if (controller.selectedImgIndex.value !=
                  controller.syllabiclistItemList.length - 1) {
                controller.selectedImgIndex.value =
                    controller.selectedImgIndex.value + 1;
              }
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 22.h),
            padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 22.v),
            decoration: AppDecoration.outlineLightBlue.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder20,
            ),
            child: GetBuilder<ExpandedViewController>(
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 57.v),
                    SizedBox(
                      height: 159.v,
                      width: 295.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(() {
                            return CustomImageView(
                              imagePath: controller.syllabiclistItemList[controller.selectedImgIndex.value].imageObjectUrl,
                              alignment: Alignment.center,
                            );
                          })
                        ],
                      ),
                    ),
                    SizedBox(height: 54.v),

                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Section Widget: Ri Arrow Up Line
  Widget _buildRiArrowUpLine() {
    return GetBuilder<ExpandedViewController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                  height: 26.adaptSize,
                  width: 26.adaptSize,
                  padding: EdgeInsets.all(5.h),
                  onTap: () {
                    controller.previousImgHandler();
                  },
                  child: CustomImageView(
                      imagePath: ImageConstant.imgRiArrowUpLine
                  )
              ),
              CustomIconButton(
                  height: 26.adaptSize,
                  width: 26.adaptSize,
                  padding: EdgeInsets.all(5.h),
                  onTap: () {
                    controller.nextImgHandler();
                  },
                  child: CustomImageView(
                      imagePath: ImageConstant.imgRiArrowUpLineGray800
                  )
              ),
            ],
          ),
        );
      },
    );
  }


}
