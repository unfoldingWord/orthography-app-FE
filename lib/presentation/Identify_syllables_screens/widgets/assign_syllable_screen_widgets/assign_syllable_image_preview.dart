
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../../completion_dialog_screens/identify_syllable_completion_dialog.dart';
import '../../controller/image_gallery_controller.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGalleryController>(builder: (controller) {
      return GestureDetector(
        /// Gesture detection for horizontal swipe
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            /// Handle swipe right
            controller.previousImgHandler();
          } else if (details.primaryVelocity! < 0) {
            /// Handle swipe left
            controller.nextImgHandler();
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 22.h),
          padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 22.v),
          decoration: AppDecoration.outlineLightBlue.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder20,
          ),
          child: GetBuilder<ImageGalleryController>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 57.v),
                  /// Image display area
                  SizedBox(
                    height: 159.v,
                    width: 295.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Arrows for navigation
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                            EdgeInsets.only(top: 80.v, bottom: 53.v),
                            child: Obx(() {
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Display previous image arrow if available
                                  controller.selectedImgIndex == 0
                                      ? Opacity(
                                    opacity: 0.2,
                                    child: CustomIconButton(
                                      height: 26.adaptSize,
                                      width: 26.adaptSize,
                                      padding: EdgeInsets.all(5.h),
                                      child: CustomImageView(
                                        imagePath: ImageConstant
                                            .imgRiArrowUpLine,
                                      ),
                                    ),
                                  )
                                      : CustomIconButton(
                                    height: 26.adaptSize,
                                    width: 26.adaptSize,
                                    padding: EdgeInsets.all(5.h),
                                    onTap: () {
                                      controller.previousImgHandler();
                                    },
                                    child: CustomImageView(
                                      imagePath: ImageConstant
                                          .imgRiArrowUpLine,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        /// Display current image
                        Obx(() {
                          return CustomImageView(
                            height: 250.v,
                            width: 250.v,
                            imagePath: controller.imageGalleryList[
                            controller.selectedImgIndex.value].fileUrl,
                            alignment: Alignment.center,
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 54.v),

                  /// Show completion dialog if images is completed
                  Obx(() {
                    if (controller.isImgCompleted.value) {
                      Future.delayed(Duration.zero, () {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async {
                                /// Return false to prevent the dialog from closing
                                return false;
                              },
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                content: Container(
                                  child: IdentifySyllableCompletionDialog(),
                                ),
                              ),
                            );
                          },
                        );
                      });
                    }
                    return SizedBox.shrink();
                  }),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
