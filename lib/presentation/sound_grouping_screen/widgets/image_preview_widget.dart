
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../completion_dialog_screens/sound_group_periodic_check_dialog.dart';
import '../../completion_dialog_screens/sound_groups_completion_dialog.dart';
import '../../completion_dialog_screens/syllabic_module_completion_dialog.dart';
import '../../syllable_groups_screen/controller/expanded_view_controller.dart';
import '../controller/sound_grouping_controller.dart';

class SoundGrpImagePreview extends StatelessWidget {
  String SyllableType;
  SoundGrpImagePreview({required this.SyllableType});
  final SoundGroupingController soundGroupController = Get.put(SoundGroupingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpandedViewController>(
      builder: (controller) {
        /// Update the preview image index
        soundGroupController.updatePreviewImageIndex(controller.selectedImgIndex.value);

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              soundGroupController.reset();
              soundGroupController.soundGroupPreviousImgHandler();
            } else if (details.primaryVelocity! < 0) {
              print('Swipe to the left');
              soundGroupController.reset();
              soundGroupController.soundGroupNextImgHandler();
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 22.h),
            padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 22.v),
            decoration: AppDecoration.outlineLightBlue.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder20,
            ),
            child: GetBuilder<ExpandedViewController>(
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 57.v),
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
                              child: Obx(
                                    () {
                                  return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      controller.selectedImgIndex == 0
                                          ? Opacity(
                                        opacity: 0.2,
                                        child: CustomIconButton(
                                          height: 26.adaptSize,
                                          width: 26.adaptSize,
                                          padding: EdgeInsets.all(5.h),
                                          child: CustomImageView(
                                            imagePath: ImageConstant
                                                .imgRiArrowUpLine,
                                          ),
                                        ),
                                      )
                                          : CustomIconButton(
                                        height: 26.adaptSize,
                                        width: 26.adaptSize,
                                        padding: EdgeInsets.all(5.h),
                                        onTap: () {
                                          // controller.previousImgHandler();
                                          soundGroupController.soundGroupPreviousImgHandler();
                                        },
                                        child: CustomImageView(
                                          imagePath: ImageConstant
                                              .imgRiArrowUpLine,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          Obx(
                                () {
                              return CustomImageView(
                                height: 250.v,
                                width: 250.v,
                                imagePath: controller
                                    .syllabiclistItemList[
                                controller.selectedImgIndex.value]
                                    .imageObjectUrl,
                                alignment: Alignment.center,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 54.v),
                    /// Dialogs for completion status
                    _buildCompletionDialogs(context),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Builds the completion dialogs
  Widget _buildCompletionDialogs(BuildContext context) {
    return Column(
      children: [
        _buildSoundGroupCompletionDialog(context),
        _buildSyllabicSoundGroupingCompletionDialog(context),
        _buildPeriodicCheckCompletionDialog(context),
      ],
    );
  }

  /// Builds the sound group completion dialog
  Widget _buildSoundGroupCompletionDialog(BuildContext context) {
    return Obx(
          () {
        if (soundGroupController.isSoundGrpCompleted.value) {
          Future.delayed(Duration.zero, () {
            return showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    /// Return false to prevent the dialog from closing
                    return false;
                  },
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    content: Container(
                      child: SoundGroupingCompletionDialog(),
                    ),
                  ),
                );
              },
            );
          });
        }
        return SizedBox.shrink();
      },
    );
  }

  /// Builds the syllabic sound grouping completion dialog
  Widget _buildSyllabicSoundGroupingCompletionDialog(BuildContext context) {
    return Obx(
          () {
        if (soundGroupController.isMonoCompleted.value == true ||
            soundGroupController.isBiGrpCompleted.value ||
            soundGroupController.isTriGrpCompleted == true ||
            soundGroupController.isPolyGrpCompleted == true) {
          Future.delayed(Duration.zero, () {
            return showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    /// Return false to prevent the dialog from closing
                    return false;
                  },
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    content: Container(
                      child: SyllabicSoundGroupingCompletionDialog(
                        SyllableType,
                      ),
                    ),
                  ),
                );
              },
            );
          });
        }
        return SizedBox.shrink();
      },
    );
  }

  /// Builds the periodic check completion dialog
  Widget _buildPeriodicCheckCompletionDialog(BuildContext context) {
    return Obx(
          () {
        if (soundGroupController.is20CountCompleted.value) {
          Future.delayed(Duration.zero, () {
            return showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    /// Return false to prevent the dialog from closing
                    return false;
                  },
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    content: Container(
                      child: PeriodicCheckCompletionDialog(),
                    ),
                  ),
                );
              },
            );
          });
        }
        return SizedBox.shrink();
      },
    );
  }
}
