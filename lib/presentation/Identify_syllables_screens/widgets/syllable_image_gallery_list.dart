
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controller/image_gallery_controller.dart';
import 'syllable_image_card_widegt.dart';

class ImageGalleryList extends StatelessWidget {
  final ImageGalleryController controller = Get.find<ImageGalleryController>();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// Skeletonizer to show skeleton loading while data is loading
      return SingleChildScrollView(
        controller: controller.imageScrollController,
        child: Column(
          children:
          [
                 /// Edit Groups will be enabled when all the images are assigned by user
                  controller.isImgCompleted.value?
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 28.h),
                      child: InkWell(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('btnClicked', true);
                            prefs.setBool('isEditButtonClicked', true);
                            Get.offAllNamed(AppRoutes.syllableGroupsScreen);
                          },
                          child: Container(
                            height: 36.h,
                            width: 95.v,
                            decoration: AppDecoration.outlineLightBlue.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder5,
                                border: Border.all(
                                  color: Color(0XFFD0D0CE),
                                  width: 1.h,
                                ),
                                color: Color(0xFF435E6F)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('EDIT GROUPS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.fSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          )),
                    ),
                  ):Container(),

                    /// Image Gallery List Widget
                    Skeletonizer(
                    enabled: controller.isLoading.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.h,
                          vertical: 30.v,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            /// Grid properties
                            mainAxisExtent: 101.v,
                            crossAxisCount: 3,
                            mainAxisSpacing: 23.h,
                            crossAxisSpacing: 23.h,
                          ),
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.imageGalleryList.length,
                          itemBuilder: (context, index) {
                            /// GestureDetector to handle taps on images
                            return Material(
                              child: InkWell(
                                splashColor: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  /// Navigate to assign syllable screen if image is incomplete
                                  Future.delayed(Duration(milliseconds: 200), () {
                                    if (!controller.imageGalleryList[index].completed) {
                                      controller.selectedImgIndex.value = index;
                                      Get.toNamed(AppRoutes.assignSyllableScreen);
                                    }
                                  });
                                },
                                child: ImageCard(cardDetails: controller.imageGalleryList[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    )
          ],
        ),
      );
    });
  }
}
