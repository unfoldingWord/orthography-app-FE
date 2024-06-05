import 'package:flutter/cupertino.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../controller/image_gallery_controller.dart';

class SyllableHeaderAction extends StatelessWidget {
  /// Creating an instance of the ImageGalleryController
  final ImageGalleryController controller = ImageGalleryController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGalleryController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 10.v),
        child: controller?.isTrainingBtnSelected?.value == true
            ? CustomImageView(
          /// Displaying a stop icon if training mode is selected
          imagePath: ImageConstant.imgGroup1000001986,
          height: 13.v,
          width: 14.h,
          onTap: () {
            /// Disposing video player when training mode is stopped
            controller?.videoPlayerController?.dispose();
            controller?.updateVideoStatus(false);
            controller?.isVideoInitialized.value = false;
          },
        )
            : CustomImageView(
          /// Displaying a play icon if training mode is not selected
          height: 30.h,
          onTap: () {
            /// Toggling training mode and initializing video if activated
            controller?.isTrainingBtnSelected.value =
            !controller.isTrainingBtnSelected.value;
            if (controller?.isTrainingBtnSelected.value == true) {
              controller?.initializeVideo();
            } else {
              controller?.videoPlayerController?.dispose();
            }
          },
          width: 30.v,
          imagePath: ImageConstant.imgVectorPlay,
        ),
      );
    });
  }
}
