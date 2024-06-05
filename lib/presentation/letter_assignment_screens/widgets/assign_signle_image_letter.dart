import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../controller/letter_assignment_controller.dart';

/// Widget to build the image preview
Widget buildImgPreviewWidget(BuildContext context, image) {
  /// Letter Assignment Controller
  final LetterAssignmentController controller = Get.put(LetterAssignmentController());
  return GestureDetector(
    onHorizontalDragEnd: (details) {
      if (details.primaryVelocity! > 0) {
        /// Handle right swipe
        controller.assignLetterTextController.clear();
        controller.isSubmitButtonEnabled.value=false;
        print(controller.assignLetterTextController.text.length);
        controller.previousImgHandler();
      } else if (details.primaryVelocity! < 0) {
        /// Handle left swipe
        controller.assignLetterTextController.clear();
        controller.isSubmitButtonEnabled.value=false;
        print(controller.assignLetterTextController.text.length);
        controller.nextImgHandler();
      }
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 22.v),
      decoration: AppDecoration.outlineLightBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 27.v),
          SizedBox(
            height: 159.v,
            width: 295.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.v, bottom: 53.v),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          imagePath:
                                              ImageConstant.imgRiArrowUpLine,
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
                                        imagePath:
                                            ImageConstant.imgRiArrowUpLine,
                                      ),
                                    ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: image,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 54.v),

        ],
      ),
    ),
  );
}

/// Widget to build container with text and an optional image
Widget buildContainer(String text1, String text2, {String? imagePath}) {
  return Container(
    width: 315.v,
    height: 50.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Color(0xffD9D9D9),
        width: 1.0,
      ),
    ),
    child: Center(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12.v),
            child: Text(
              text1,
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (imagePath != null)
            Container(
              height: 40.h,
              width: 40.h,
              padding: EdgeInsets.all(10.v),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xff068CDB),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomImageView(imagePath: imagePath),
              ),
            ),
          Text(
            text2,
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,

            ),
          ),
        ],
      ),
    ),
  );
}

/// Widget to build the bottom navigation bar
Widget buildBottomNavigationButtonBar(BuildContext context, isGroupAssignment) {
  /// Letter Assignment Controller
  final LetterAssignmentController letterAssignmentController = Get.put(LetterAssignmentController());
  return Obx((){
    return Padding(
      padding: EdgeInsets.only(left: 28.v, right: 28.v, bottom: 18.h),
      child: letterAssignmentController.isSubmitButtonEnabled.value
          ? InkWell(
        onTap: () {
          letterAssignmentController.handleAssignLetters(context,isGroupAssignment);
        },
        child: Container(
          width: 315.v,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff00B85E),
            border: Border.all(
              color: Color(0xffD9D9D9),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              'SUBMIT',
              style: TextStyle(
                fontSize: 20.fSize,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
          : Opacity(
        opacity: 0.2,
        child: Container(
          width: 315.v,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff00B85E),
            border: Border.all(
              color: Color(0xffD9D9D9),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              'SUBMIT',
              style: TextStyle(
                fontSize: 20.fSize,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  });
}
