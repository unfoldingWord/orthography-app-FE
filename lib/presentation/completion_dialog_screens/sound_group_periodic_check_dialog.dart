import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../sound_grouping_screen/controller/sound_grouping_controller.dart';

class PeriodicCheckCompletionDialog extends StatelessWidget {
  SoundGroupingController controller = SoundGroupingController();
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
              'Great job so far! Keep up the fantastic work.',
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
                'Perform a quick check to ensure your images are accurately placed in their corresponding sound groups.',
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
          Material(
            color: Colors.transparent,
            child: InkWell(
                splashColor: Colors.grey,
                onTap: () {
                  Future.delayed(Duration(milliseconds: 200), () async {
                    controller.isSoundGrpCompleted.value = false;
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
        ],
      ),
    );
  }
}
