import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

class SyllabicRowWidget extends StatelessWidget {
  String SyllabicName;
  dynamic SyllabicList;
  dynamic SyllabicNumber;

  /// Constructor to initialize variables
  SyllabicRowWidget({
    required this.SyllabicName,
    required this.SyllabicList,
    required this.SyllabicNumber,
  });


  @override
  Widget build(BuildContext context) {
    /// Check if SyllabicList has elements
    return SyllabicList.length > 0
        ? Column(
      children: [
        /// Header row
        Padding(
          padding: EdgeInsets.only(left: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Syllabic name
              Text(
                '${SyllabicName} Syllabic',
                style: CustomTextStyles.titleMediumSemiBold_1,
              ),
              /// See More button
              InkWell(
                onTap: () {
                  /// Navigate to individual syllabic list screen
                  Get.toNamed(
                    AppRoutes.individualSyllabicList,
                    arguments: {
                      'syllableType': SyllabicName,
                      'number': SyllabicNumber
                    },
                  );
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

        /// Syllabic image list
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
                    /// Individual syllabic image
                    Container(
                      width: 90.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.h,
                        vertical: 19.v,
                      ),
                      decoration: AppDecoration.outlineLightblue500.copyWith(borderRadius: BorderRadiusStyle.roundedBorder5,),
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
    /// Return an empty container if SyllabicList is empty
        : Container();
  }
}

