import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../controller/sound_grouping_controller.dart';

class SeeMoreSoundGroupingScreen extends StatelessWidget {
  /// Initialize controller and arguments
  final SoundGroupingController syllableGroupsController = Get.put(SoundGroupingController());
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17.v),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 22.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back arrow
                        CustomImageView(
                          imagePath: ImageConstant.imgRiArrowUpLine,
                          height: 17.v,
                          width: 19.h,
                          margin: EdgeInsets.only(bottom: 77.v),
                          onTap: () {
                            Get.back();
                          },
                        ),
                        /// Preview image container
                        Container(
                          height: 100.v,
                          width: 90.h,
                          margin: EdgeInsets.only(
                            left: 93.h,
                            top: 4.v,
                          ),
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: 5.h,
                          //   vertical: 8.v,
                          // ),
                          decoration: AppDecoration.outlineGreenA.copyWith(
                            borderRadius: BorderRadiusStyle.circleBorder45,
                          ),
                          child: CustomImageView(
                            imagePath: arguments['soundGroupImg'],
                            alignment: Alignment.center,
                            height: 50.h,
                            width: 50.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 29.v),
                  Expanded(
                    child: _buildGridView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Method to build GridView for displaying images
  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 101.v,
        crossAxisCount: 3,
        mainAxisSpacing: 19.h,
        crossAxisSpacing: 1.h,
      ),
      physics: NeverScrollableScrollPhysics(),
      itemCount: arguments['soundGroupList'].length,
      itemBuilder: (context, index) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h),
            child: GestureDetector(
              onTap: () {
                // Handle onTap event
              },
              child: Container(
                height: 100.v,
                width: 90.h,
                padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 10.v),
                decoration: AppDecoration.outlineLightblue500.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder5,
                ),
                child: CustomImageView(
                  imagePath: arguments['soundGroupList'][index].imageObjectUrl,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
