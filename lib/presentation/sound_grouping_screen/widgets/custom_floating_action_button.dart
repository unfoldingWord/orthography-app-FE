import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double halfWidth = scaffoldGeometry.scaffoldSize.width / 2;
    final double fabX = halfWidth - 40.h;
    final double fabY = scaffoldGeometry.contentBottom - 38.h;
    return Offset(fabX, fabY);
  }
}