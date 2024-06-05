import 'package:flutter/cupertino.dart';
import 'package:orthoappflutter/core/app_export.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 87.adaptSize,
        width: 87.adaptSize,
        child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomImageView(
                  imagePath:
                  ImageConstant.imgOrthographyLog,
                  height: 87.adaptSize,
                  width: 87.adaptSize,
                  alignment: Alignment.center),
              CustomImageView(
                  imagePath: ImageConstant.imgEllipse5,
                  height: 1.v,
                  width: 49.h,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 11.v))
            ]));
  }
}
