import 'dart:async';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../syllable_groups_screen/controller/expanded_view_controller.dart';
import '../controller/sound_grouping_controller.dart';

class SoundGroupingBottomNavigationWidget extends StatelessWidget {
  final SoundGroupingController soundGroupController = Get.put(SoundGroupingController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGalleryController>(
      builder: (controller) {
        return controller.isTrainingBtnSelected.value == true
            ? Opacity(
          opacity: 0.2,
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 20.h,
            child: SizedBox(
              height: 50.h,
              child: Container(
                height: 80.h,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 29.h),
                      child: Container(
                        child: Text(
                          "lbl_reset".tr,
                          style: CustomTextStyles.titleMediumBlack900,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 29.h),
                      child: Container(
                        child: Text(
                          "lbl_submit".tr,
                          style: CustomTextStyles.titleMediumGreenA700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            : BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 20.h,
          child: SizedBox(
            height: 50.h,
            child: Container(
              height: 80.h,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 29.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Color(0xffC5C2C2FF),
                        onTap: () {
                          /// Reset sound grouping
                          soundGroupController.reset();
                        },
                        child: Container(
                          child: Text(
                            "lbl_reset".tr,
                            style: CustomTextStyles.titleMediumBlack900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 29.h),
                    child: GetBuilder<ExpandedViewController>(
                      builder: (controller) {
                        return InkWell(
                          splashColor: Color(0xffC5C2C2FF),

                          onTap: () {
                            if (soundGroupController.selectedIndex.value == -1) {
                              /// Show a snackBar if no sound group is selected or created
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select or create a sound group'),
                                ),
                              );
                              /// Remove the snackBar after 2 seconds
                              Timer(Duration(seconds: 2), () {
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              });
                            } else {
                              var imId = controller.syllabiclistItemList[soundGroupController.previewImageIndex.value].imageId;
                              var sgId = soundGroupController.SoundGroupList[soundGroupController.selectedIndex.value].soundGroupId;
                              /// Assign sound group Api Call
                              soundGroupController.assignSoundGroup(imId, sgId, context);
                            }
                          },
                          child: Container(
                            child: Text(
                              "lbl_submit".tr,
                              style: CustomTextStyles.titleMediumGreenA700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
