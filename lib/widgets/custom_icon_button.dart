import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
// import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child:IconButton(
            padding: EdgeInsets.zero,
            icon: Container(
              height: height ?? 0,
              width: width ?? 0,
              padding: padding ?? EdgeInsets.zero,
              decoration: decoration ??
                  BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(13.h),
                  ),
              child: child,
            ),
            onPressed: onTap,
          ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray100.withOpacity(0.46),
        borderRadius: BorderRadius.circular(13.h),
      );
  static BoxDecoration get fillIndigoA => BoxDecoration(
        color: appTheme.indigoA200,
        borderRadius: BorderRadius.circular(15.h),
      );

  static BoxDecoration get fillOnPrimaryContainerTL13 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.46),
        borderRadius: BorderRadius.circular(13.h),
      );

  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green50,
        borderRadius: BorderRadius.circular(13.h),
      );
}
