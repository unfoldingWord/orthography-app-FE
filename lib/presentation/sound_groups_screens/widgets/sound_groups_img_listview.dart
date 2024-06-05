import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controller/sound_groups_controller.dart';

class SoundGroupImageListview extends StatelessWidget {
  final SoundGroupsController soundGroupsController = Get.put(SoundGroupsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Skeletonizer(
        enabled: soundGroupsController.isLoading.value,
        child: SizedBox(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 6.v),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.v),
              child: Wrap(
                spacing: 5.h,
                children: List.generate(
                  soundGroupsController.AllSoundGroupList.length,
                      (index) {
                    /// Check if the sound group has images
                    return soundGroupsController.AllSoundGroupList[index].imageList.length == 0
                        ? Container()
                        : Column(
                      children: [
                        /// Sound Group Hero Image Widget
                        Row(
                          children: [
                            Container(
                              height: 50.h,
                              width: 50.h,
                              padding: EdgeInsets.all(10.v),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: CustomImageView(
                                  imagePath: soundGroupsController.AllSoundGroupList[index].imageUrl,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /// See More Button Widget
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              /// Navigate to see more screen with sound group details
                              Get.toNamed(
                                AppRoutes.seeMoreSoundGroupsScreen,
                                arguments: {
                                  'soundGroupImg': soundGroupsController.AllSoundGroupList[index].imageUrl,
                                  'soundGroupList': soundGroupsController.AllSoundGroupList[index].imageList,
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 3.v, right: 20.v),
                              child: Text(
                                'See More',
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.v),
                        /// Images List Of Each Sound Group Widget
                        Row(
                          children: [
                            SizedBox(
                              child: Wrap(
                                spacing: 25.v,
                                children: List.generate(
                                  /// Generate up to 3 images for each sound group
                                  min(soundGroupsController.AllSoundGroupList[index].imageList.length, 3),
                                      (index1) {
                                    return Container(
                                      height: 100.v,
                                      width: 90.h,
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 9.v),
                                      decoration: AppDecoration.outlineLightblue500.copyWith(
                                        borderRadius: BorderRadiusStyle.roundedBorder5,
                                      ),
                                      child: CustomImageView(
                                        imagePath: soundGroupsController.AllSoundGroupList[index].imageList[index1].imageObjectUrl,
                                        alignment: Alignment.center,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
