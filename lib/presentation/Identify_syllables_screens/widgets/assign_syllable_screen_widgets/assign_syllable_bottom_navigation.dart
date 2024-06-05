import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../controller/image_gallery_controller.dart';

class SyllableBottomNavigation extends StatelessWidget {
  const SyllableBottomNavigation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGalleryController>(builder: (controller) {
      return Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 31.h, vertical: 18.v),

        /// Padding for the container
        decoration: AppDecoration.outlineBlack.copyWith(
          borderRadius: controller.isTrainingBtnSelected.value == true
              ? BorderRadius.zero

              /// No border radius if training button is selected
              : BorderRadiusStyle.customBorderBL8,

          /// Apply border radius otherwise
          color: controller.isTrainingBtnSelected.value == true
              ? Colors.black.withOpacity(0.5)

              /// Apply opacity to the background color if training button is selected
              : null,

          /// No background color if training button is not selected
        ),
        child: GetBuilder<ImageGalleryController>(builder: (controller) {
          return controller.isTrainingBtnSelected.value == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("lbl_reset".tr,
                          style: CustomTextStyles.titleMediumSemiBold),
                    ),
                    Container(
                      child: Text("lbl_submit".tr,
                          style: CustomTextStyles.titleMediumGreenA700),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Color(0xffC5C2C2FF),
                        onTap: () {
                          /// Reset onTap
                          controller.textController.text = '0';
                          controller.counter.value = 0;
                          controller.updateOnTapValue();
                        },
                        child: Container(
                          child: Text("lbl_reset".tr,
                              style: CustomTextStyles.titleMediumSemiBold),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Color(0xffC5C2C2FF),
                        onTap: () {
                          /// Submit onTap
                          controller.isSubmitBtnClicked==0?
                          controller.submitSyllables(
                              context,
                              controller.imageGalleryList[controller.selectedImgIndex.value].id,
                              controller.imageGalleryList[controller.selectedImgIndex.value].onTap):null;
                        },
                        child: Container(
                          child: Text(
                            /// Submit label
                              "lbl_submit".tr,
                              ///Text style for submit label
                              style: CustomTextStyles.titleMediumGreenA700),
                        ),
                      ),
                    )
                  ],
                );
        }),
      );
    });
  }
}
