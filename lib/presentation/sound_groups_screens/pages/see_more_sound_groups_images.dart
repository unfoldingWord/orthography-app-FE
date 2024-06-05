import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../sound_grouping_screen/controller/sound_grouping_controller.dart';
import '../../sound_grouping_screen/widgets/update_sound_grouping.dart';

class SeeMoreSoundGroupsScreen extends StatelessWidget {
  /// Controller for managing sound grouping
  final SoundGroupingController soundGroupingController = Get.put(SoundGroupingController());

  /// Retrieve arguments passed through navigation or default to an empty map
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 17.v),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Back button and image preview section
                        Padding(
                          padding: EdgeInsets.only(left: 22.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Back button
                              CustomImageView(
                                imagePath: ImageConstant.imgRiArrowUpLine,
                                height: 17.v,
                                width: 19.h,
                                margin: EdgeInsets.only(bottom: 77.v),
                                onTap: () {
                                  Get.back();
                                },
                              ),
                              /// Image preview
                              Container(
                                height: 100.v,
                                width: 90.h,
                                margin: EdgeInsets.only(
                                  left: 93.h,
                                  top: 4.v,
                                ),
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
                        /// Vertical spacing
                        SizedBox(height: 29.v),
                        /// Grid view of sound groups
                        _buildGridView(),
                        /// Vertical spacing
                        SizedBox(height: 10.v),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget for building the grid view of sound groups
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
            padding: EdgeInsets.only(left: 15.h, right: 15.h),
            child: GestureDetector(
              /// Long press action to show update dialog
              onLongPressEnd: (details) {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: UpdateSoundGroupingScreen(
                        arguments['soundGroupList'][index].imageObjectUrl,
                        arguments['soundGroupList'][index].imageId,
                      ),
                    );
                  },
                );
              },
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
