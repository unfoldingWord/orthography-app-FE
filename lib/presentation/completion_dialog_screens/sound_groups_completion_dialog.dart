import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/controller/sound_grouping_controller.dart';

import '../syllable_groups_screen/controller/syllable_groups_controller.dart';

class SoundGroupingCompletionDialog extends StatelessWidget {
  SoundGroupingController controller = SoundGroupingController();
  SyllableGroupsController syllableGroupsController =
      Get.put(SyllableGroupsController());
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 324.h,
      padding: EdgeInsets.symmetric(vertical: 12.v),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              'You have successfully Completed Sound Grouping',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(
                height: 1.60,
              ),
            ),
          ),
          SizedBox(height: 7.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                'You can now view the Sound groups or go back to homepage',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.bodySmallGray800.copyWith(
                  height: 1.50,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                    splashColor: Colors.grey,
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 200), () async {
                        controller.isSoundGrpCompleted.value = false;
                        Get.toNamed(AppRoutes.homepageOneScreen);
                      });
                    },
                    child: Ink(
                      height: 36.h,
                      width: 123.v,
                      decoration: AppDecoration.outlineLightBlue.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder5,
                          border: Border.all(
                            color: Color(0XFFD0D0CE),
                            width: 1.h,
                          ),
                          color: Colors.white),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('HOMEPAGE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11.fSize,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: Colors.grey,
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 200), () async {
                          controller.isSoundGrpCompleted.value = false;
                          Get.back();
                          Get.offAllNamed(AppRoutes.soundGroupGalleryScreen);
                        });
                      },
                      child: Ink(
                        height: 36.h,
                        width: 123.v,
                        decoration: AppDecoration.outlineLightBlue.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder5,
                            border: Border.all(
                              color: Color(0XFFD0D0CE),
                              width: 1.h,
                            ),
                          color: Color(0xFF435E6F).withOpacity(0.9),),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('SOUND GROUPS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 11.fSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
