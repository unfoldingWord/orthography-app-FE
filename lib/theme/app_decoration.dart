import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

class AppDecoration {
  /// Fill decorations

  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );

  static BoxDecoration get outlineGreenA => BoxDecoration(
        border: Border.all(
          color: appTheme.greenA700,
          width: 3.h,
        ),
      );

  static BoxDecoration get outlineLightBlue => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: Color(0XFF06AFF2),
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.indigo9000c,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              5.01,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineLightblue500 => BoxDecoration(
        color: appTheme.whiteA700.withOpacity(0.8),
        border: Border.all(
          color: Color(0XFF06AFF2),
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.indigo9000c,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              1.34,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineDarkblue500 => BoxDecoration(
        color: appTheme.whiteA700.withOpacity(0.8),
        border: Border.all(
          color: Color(0xff2684FF),
          width: 1.5.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              1.34,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineGreyLight500 => BoxDecoration(
        color: appTheme.whiteA700.withOpacity(0.8),
        border: Border.all(
          color: Color(0XFF889DB0),
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              1.34,
              0,
            ),
          ),
        ],
      );

  /// Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.04),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              -4,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlueGray => BoxDecoration(
        border: Border.all(
          color: appTheme.blueGray10001,
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
  /// Custom borders
  static BorderRadius get customBorderBL8 => BorderRadius.vertical(
        bottom: Radius.circular(8.h),
      );

  /// Rounded borders
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );

  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );

  /// Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
  static BorderRadius get roundedBorder3 => BorderRadius.circular(
        3.h,
      );

  static BorderRadius get circleBorder45 => BorderRadius.circular(
        45.h,
      );
}

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;
