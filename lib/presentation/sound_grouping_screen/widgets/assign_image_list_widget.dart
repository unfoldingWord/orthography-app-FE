import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../controller/sound_grouping_controller.dart';

class SoundGrpImages extends StatelessWidget {
  final SoundGroupingController soundGroupController = Get.put(SoundGroupingController());
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(left: 23.v, right: 23.v),
          child: Obx(() {
            return Wrap(
                spacing: 5.v,
                children: List.generate(
                    min(soundGroupController.SoundGroupImagesList.length, 4),
                    (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(4.v),
                      child: Container(
                          height: 78.v,
                          width: 70.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.h, vertical: 9.v),
                          decoration: index == 0
                              ? AppDecoration.outlineDarkblue500.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder5,
                                )
                              : AppDecoration.outlineGreyLight500.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder5,
                                ),
                          child: CustomImageView(
                            imagePath: soundGroupController.SoundGroupImagesList[index].imageObjectUrl,
                            alignment: Alignment.center,
                          )),
                    ),
                  );
                }));
          }),
        ),
      ),
    );
  }
}
