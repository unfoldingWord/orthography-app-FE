import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

class SyllabicImageRow extends StatelessWidget {
  String SyllabicName; /// Name of the syllabic type
  dynamic SyllabicList; /// List of syllabic images
  dynamic? isSyllabicCompleted; /// Indicates if the syllabic type is completed
  dynamic SyllabicNumber; /// Number of syllabics

  SyllabicImageRow({
    required this.SyllabicName,
    required this.SyllabicList,
    this.isSyllabicCompleted,
    required this.SyllabicNumber,
  });

  @override
  Widget build(BuildContext context) {
    /// Check if the syllabic list has elements
    return SyllabicList.length > 0
        ? Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /// Display the name of the syllabic type
                  Text(
                    '${SyllabicName} Syllabic',
                    style: CustomTextStyles.titleMediumSemiBold_1,
                  ),
                  /// Display a checkmark if the syllabic type is completed
                  isSyllabicCompleted
                      ? Padding(
                    padding: EdgeInsets.only(left: 8.v),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgCheckmark,
                      alignment: Alignment.topRight,
                      height: 20.h,
                      width: 20.v,
                    ),
                  )
                      : Container(),
                ],
              ),
              /// 'See More' option to navigate to sound syllabic screen
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.soundSyllablicScreen,
                      arguments: {
                        'syllableType': SyllabicName,
                        'number': SyllabicNumber
                      });
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3.v),
                  child: Text(
                    'See More',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Container(
            height: 100.v,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: SyllabicList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: 90.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.h,
                        vertical: 19.v,
                      ),
                      decoration: AppDecoration.outlineLightblue500
                          .copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Obx(
                            () => CustomImageView(
                          imagePath: SyllabicList[index].imageObjectUrl,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.v),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    )
        : Container(); /// Return an empty container if the syllabic list is empty
  }
}
