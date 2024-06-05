import 'package:orthoappflutter/presentation/Identify_syllables_screens/controller/image_gallery_controller.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

class IdentifySyllableCompletionDialog extends StatelessWidget {
  ImageGalleryController controller = ImageGalleryController();
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
              'You have successfully Completed identifying Syllables',
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
                'You can now view the syllable groups or go back to homepage',
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
                  splashColor: Colors.grey.withAlpha(120),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 200), () async {
                      controller.isImgCompleted.value = false;
                      Get.offAllNamed(AppRoutes.homepageOneScreen);
                    });
                  },
                  child: Ink(
                    height: 36.h,
                    width: 123.v,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0XFFD0D0CE),
                        width: 1.h,
                      ),
                      color: Colors.white, // Set color here, within Ink
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('HOMEPAGE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11.fSize,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.grey.withAlpha(120),
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 200), () async {
                        controller.isImgCompleted.value = false;
                        Get.offAllNamed(AppRoutes.syllableGroupsScreen);

                      });
                    },
                    child: Ink(
                      height: 36.h,
                      width: 123.v,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0XFFD0D0CE),
                          width: 1.h,
                        ),
                        color: Color(0xFF435E6F).withOpacity(0.9),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'SYLLABLE GROUPS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.fSize,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
