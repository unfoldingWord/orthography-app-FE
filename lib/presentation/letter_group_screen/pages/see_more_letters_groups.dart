import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/letter_group_screen/pages/update_letter_group.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controller/letter_group_controller.dart';

class SeeMoreLetterGroupsGroupsScreen extends StatelessWidget {
  /// Extracting arguments and initializing controller
  final Map<String, dynamic> arguments = Get.arguments ?? {};
  final LetterGroupsController letterGroupsController = Get.put(LetterGroupsController());
  @override
  Widget build(BuildContext context) {
    /// Fetching data on initialization
    letterGroupsController.fetchLetterByGroups(arguments['letter']);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 17.v),
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 22.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Custom back button
                            CustomImageView(
                              imagePath: ImageConstant.imgRiArrowUpLine,
                              height: 17.v,
                              width: 19.h,
                              margin: EdgeInsets.only(bottom: 77.v),
                              onTap: () {
                                Get.back();
                              },
                            ),
                            /// Displaying letter
                            Container(
                              height: 100.v,
                              width: 90.h,
                              margin: EdgeInsets.only(left: 93.h, top: 4.v),
                              padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 18.v),
                              decoration: AppDecoration.outlineGreenA.copyWith(
                                borderRadius: BorderRadiusStyle.circleBorder45,
                              ),
                              child: Center(
                                  child: Text(
                                    arguments['letter'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 48.fSize),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 29.v),
                      _buildGridView(), // Displaying grid view
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget for building grid view
  Widget _buildGridView() {
    return Obx(() {
      return Skeletonizer(
        enabled: letterGroupsController.isLoading.value,
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 101.v,
                crossAxisCount: 3,
                mainAxisSpacing: 19.h,
                crossAxisSpacing: 1.h),
            physics: NeverScrollableScrollPhysics(),
            itemCount: letterGroupsController.singleLetterGalleryList.length,
            itemBuilder: (context, index) {
              var imageId = letterGroupsController.singleLetterGalleryList[index].imageId;
              var imageUrl = letterGroupsController.singleLetterGalleryList[index].imageObjectUrl;
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.h, right: 15.h),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 100.v,
                      width: 90.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                        vertical: 10.v,
                      ),
                      decoration: AppDecoration.outlineLightblue500.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: GestureDetector(
                        /// Long press to show update dialog
                        onLongPressEnd: (details) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: UpdateLetterGroupScreen(
                                  imageId: imageId,
                                  imageUrl: imageUrl,
                                ),
                              );
                            },
                          );
                        },
                        child: CustomImageView(
                          imagePath: imageUrl,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }
}
