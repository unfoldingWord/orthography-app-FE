import 'package:orthoappflutter/presentation/Identify_syllables_screens/controller/image_gallery_controller.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

class AssignLettersDataLostDialog extends StatelessWidget {
  ImageGalleryController controller = ImageGalleryController();
  dynamic imageIdsList;
  var index;
  AssignLettersDataLostDialog({required this.imageIdsList,index});
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

          SizedBox(height: 7.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                'Letters assigned individually will be over written if you assign letters to the whole group',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.fSize,height:1.5)
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
                          color: Colors.white),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('CANCEL',
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
                          Get.toNamed(
                            AppRoutes.assignGroupLetterScreen,
                            arguments: {
                              'selectedGraphemeIndex': index,
                              'ImgIdsList': imageIdsList,
                            },
                          );
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
                            color: Color(0xFF435E6F)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('OKAY',
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
