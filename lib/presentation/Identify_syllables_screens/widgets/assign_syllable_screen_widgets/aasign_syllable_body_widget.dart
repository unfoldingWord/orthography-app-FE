import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../controller/image_gallery_controller.dart';
import 'assign_syllable_image_preview.dart';
import 'assign_syllable_info_widegt.dart';

class SyllableWidget extends StatelessWidget {
  final FocusNode focusNode = FocusNode(); /// Focus node for text field
  final ScrollController _scrollController = ScrollController(); /// Scroll controller
  final ImageGalleryController controller = ImageGalleryController(); /// Instance of ImageGalleryController

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController, /// Attach scroll controller to SingleChildScrollView
      physics: BouncingScrollPhysics(), /// Bouncing scroll physics
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(height: 21.v), /// Vertical spacing
            ImagePreview(), /// Image preview widget
            SizedBox(height: 13.v), /// Vertical spacing
            Align(
              alignment: Alignment.centerRight,
              child: GetBuilder<ImageGalleryController>(builder: (controller) {
                return InkWell(
                  onTap: () {
                    /// Skip image onTap
                    controller.textController.text = '0';
                    controller.counter.value = 0;
                    controller.skipImage(
                      context,
                      controller.imageGalleryList[controller.selectedImgIndex.value].id,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 22.h),
                    child: Text(
                      "lbl_skip".tr, // Localized text
                      style: CustomTextStyles.titleMediumBlueA400, /// Text style
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 38.v), /// Vertical spacing
            InfoWidget(), /// Information widget
            SizedBox(height: 55.v), /// Vertical spacing
            _buildCounterWidget(context),/// Counter widget
          ],
        ),
      ),
    );
  }

  /// Widget for building the counter section
  Widget _buildCounterWidget(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      if (!isKeyboardVisible) {
        /// If keyboard is not visible, unfocus focus node and scroll to the top
        focusNode.unfocus();
        controller.shouldKeyPad.value = false;
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        });
      }
      return GetBuilder<ImageGalleryController>(builder: (controller) {
        return SizedBox(
          height: 273.v,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 88.v,
                  width: 206.h,
                  child: Row(
                    children: [
                      /// Decrease Counter Button
                      CustomIconButton(
                        height: 30.adaptSize,
                        width: 30.adaptSize,
                        padding: EdgeInsets.all(5.h),
                        onTap: () {
                          /// Decrease counter onTap
                          focusNode.unfocus();
                          controller.shouldKeyPad.value = false;
                          if (controller.counter == 0) {
                            print('not clicked');
                          } else {
                            controller.shouldKeyPad.value = false;
                            controller.counter--;
                            controller.textController.text = controller.counter.toString();
                            controller.updateOnTapValue();
                          }
                        },
                        decoration: IconButtonStyleHelper.fillIndigoA,
                        child: CustomImageView(imagePath: 'assets/images/minus.svg'), /// Icon
                      ),

                      Obx(() {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              /// Toggle counter onTap
                              controller.shouldKeyPad.value = true;
                              print(controller.shouldKeyPad.value);

                              /// Request focus when shouldKeyPad becomes true
                              if (controller.shouldKeyPad.value) {
                                focusNode.requestFocus();
                              }
                            },
                            child: controller.shouldKeyPad.value
                                ? TextField(
                              controller: controller.textController,
                              onChanged: (val) {
                                controller.updateCounterVal(int.parse(val));
                                controller.updateOnTapValue();
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, /// Allow only digits
                                LengthLimitingTextInputFormatter(1), /// Limit to one digit
                              ],
                              keyboardType: TextInputType.number, /// Numeric keyboard
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.center, /// Center alignment
                              style: TextStyle(
                                color: Color(0XFF222222),
                                fontSize: 85.fSize,
                                fontWeight: FontWeight.w400,
                              ),
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none, /// No border
                                fillColor: Colors.white, /// Fill color
                                filled: true, // Filled
                              ),
                            )
                                : Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${controller.imageGalleryList[controller.selectedImgIndex.value].onTap.toString()}",
                                style: TextStyle(
                                  fontSize: 85.fSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      /// Increase Counter Button
                      CustomIconButton(
                        height: 30.adaptSize,
                        width: 30.adaptSize,
                        padding: EdgeInsets.all(5.h),
                        onTap: () {
                          controller.counter.value=controller.imageGalleryList[controller.selectedImgIndex.value].onTap;
                          /// Increase counter onTap
                          focusNode.unfocus();
                          controller.shouldKeyPad.value = false;
                          if (controller.counter.value > 8) {
                          } else {
                            controller.counter.value=controller.imageGalleryList[controller.selectedImgIndex.value].onTap;
                            controller.counter.value=controller.counter.value + 1;
                            controller.textController.text = controller.counter.toString();
                            controller.updateOnTapValue();
                          }
                        },
                        decoration: IconButtonStyleHelper.fillIndigoA,
                        child: CustomImageView(imagePath: 'assets/images/img_plus.svg'), // Icon
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
