
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../syllable_groups_screen/controller/expanded_view_controller.dart';
import '../controller/sound_grouping_controller.dart';

class SoundGrpSkipImg extends StatelessWidget {
  /// Create an instance of SoundGroupingController using Get.put() method
  final SoundGroupingController soundGroupController = Get.put(SoundGroupingController());

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GetBuilder<ExpandedViewController>(
        builder: (controller) {
          return InkWell(
            onTap: () {
              /// Get the image ID of the current image being previewed
              var imId = controller.syllabiclistItemList[soundGroupController.previewImageIndex.value].imageId;
              /// Call the skipImage function in the controller
              soundGroupController.skipImage(
                  context, imId);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 22.h),
              child: Text(
                "lbl_skip".tr,
                style: CustomTextStyles.titleMediumBlueA400,
              ),
            ),
          );
        },
      ),
    );
  }
}
