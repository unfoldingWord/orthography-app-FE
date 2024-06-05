import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_checkbox_button.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../controller/video_controller.dart';

final VideoController controller = Get.put(VideoController());

/// Widget for the Video List
Widget buildVideoList() {
  return Obx(() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: ListView.builder(
          itemCount: controller?.videoList?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.playVideoAtIndex(index);
              },
              child: buildVideoListItem(index)// Extracted method for video list item.
            );
          },
        ),
      ),
    );
  });
}

/// Widget for each video list item
Widget buildVideoListItem(int index) {
  bool isSelected = index == controller.selectedVideoIndex.value;
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(8.h),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.h),
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 13.v,
          ),
          decoration: isSelected
              ? AppDecoration.outlineBlueGray.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder15,
          )
              : AppDecoration.outlineBlueGray.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder15,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 48.v,
                width: 71.h,
                margin: EdgeInsets.only(left: 4.h),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomImageView(
                      imagePath: controller.videoList[index].thumbnailFileUrl,
                      height: 48.v,
                      width: 71.h,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 13.h,
                  top: 13.v,
                  bottom: 14.v,
                ),
                child: Text(
                  controller.videoList[index].title,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  top: 12.v,
                  bottom: 14.v,
                ),
                child: CustomImageView(
                  imagePath: controller.videoList[index].watched
                      ? ImageConstant.imgCheckmark
                      : ImageConstant.imgVectorPlay,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Widget for the Don't Show Option
Widget buildOption() {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: EdgeInsets.only(left: 140.h),
      child: Obx(
            () => CustomCheckboxButton(
          alignment: Alignment.centerRight,
          text: "msg_don_t_show_this".tr,
          value: controller.ShowBtn.value,
          onChange: (value) {
            controller.ShowBtn.value = value;
            controller.ShowVideo(value);
          },
        ),
      ),
    ),
  );
}

/// Widget for the Start Button
Widget buildStartButton() {
  return Obx(() {
    return controller.hasWatchedAllVideos.value
        ? CustomElevatedButton(
      text: "msg_let_s_get_started".tr,
      margin: EdgeInsets.only(
        left: 41.h,
        right: 21.h,
      ),
      buttonStyle: CustomButtonStyles.fillPrimaryTL25,
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700_1,
      alignment: Alignment.centerRight,
      onPressed: () {
        Get.offAllNamed(
          AppRoutes.homepageOneScreen,
        );
      },
    )
        : Opacity(
      opacity: 0.3,
      child: CustomElevatedButton(
        text: "msg_let_s_get_started".tr,
        margin: EdgeInsets.only(
          left: 41.h,
          right: 21.h,
        ),
        buttonStyle: CustomButtonStyles.fillPrimaryTL25,
        buttonTextStyle: CustomTextStyles.titleMediumWhiteA700_1,
        alignment: Alignment.centerRight,
      ),
    );
  });
}