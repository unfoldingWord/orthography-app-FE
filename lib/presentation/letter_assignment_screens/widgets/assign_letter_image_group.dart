import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

/// Widget for building the list view of selected graphemes.
Widget buildListView(selectedGraphemeList,height, ScrollController controller2) {
  return Padding(
    padding: EdgeInsets.only(left: 22.h, top: 10.v, right: 22.h),
    child: Container(
       // height: 320.h,
      height: height,
      width: double.maxFinite,
      child: Scrollbar(
        isAlwaysShown: true,
        radius: Radius.circular(10),
        thickness: 5,
        child: GridView.builder(
          controller: controller2,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 98.v,
            crossAxisCount: 3,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.h,
          ),
          itemCount: selectedGraphemeList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 15.v),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 100.v,
                  width: 190.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 9.v),
                  decoration: AppDecoration.outlineLightblue500.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: SizedBox(
                    height: 58.h,
                    width: 59.v,
                    child: CustomImageView(
                      imagePath: selectedGraphemeList[index].imageObjectUrl,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

