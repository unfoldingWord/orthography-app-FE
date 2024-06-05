import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

import '../letter_assignment_screens/controller/letter_assignment_controller.dart';


class LetterAssignSingleSoundCompletionDialog extends StatelessWidget {
  String ImageUrl;
  LetterAssignSingleSoundCompletionDialog({required this.ImageUrl});
  final LetterAssignmentController letterAssignmentController = Get.put(LetterAssignmentController());

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
              'You have successfully Completed Assigning Letters for ',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w500,
                height: 1.5
              )
            ),
          ),
          SizedBox(height: 20.v),
          Padding(
            padding: EdgeInsets.only(bottom: 6.v),
            child: Container(
              height: 50.h,
              width: 50.h,
              padding: EdgeInsets.all(10.v),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xffEF802F),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: ImageUrl,
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
                        letterAssignmentController.isSGAssignmentCompleted.value = false;
                        Get.offAllNamed(AppRoutes.homepageOneScreen);
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
                          letterAssignmentController.isSGAssignmentCompleted.value = false;
                          Get.back();
                          Get.offAllNamed(AppRoutes.letterAssignmentGallery);
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
                            color: Color(0xFF435E6F).withOpacity(0.9),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('LETTER GALLERY',
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
