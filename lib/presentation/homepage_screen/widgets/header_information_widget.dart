
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../widgets/app_bar/app_bar_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';

class HomePageHeaderInfo extends StatelessWidget {
  final GlobalKey<ScaffoldState> HomePageClassKey;

  /// Constructor to initialize the key
  HomePageHeaderInfo({required this.HomePageClassKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.03, -0.03),
          end: Alignment(0, 1),
          colors: [Color(0XE5496173), Color(0XFF294151)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(
            MediaQuery.of(context).size.width,
            2.0,
          ),
        ),
      ),
      child: Stack(
        children: [
          Builder(
            builder: (BuildContext builderContext) {
              return Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: CustomAppBar(
                  leadingWidth: 45.h,
                  leading: AppbarImage(
                    svgPath: ImageConstant.imgMenu41,
                    onTap: () {
                      /// Opens the drawer when the menu icon is tapped
                      HomePageClassKey.currentState?.openDrawer();
                    },
                    margin: EdgeInsets.only(left: 23.v, top: 10.h, bottom: 10.h),
                  ),
                  centerTitle: true,
                ),
              );
            },
          ),
          Positioned(
            top: 61.h,
            left: 48.v,
            child: Text(
              "Let's start",
              style: TextStyle(
                fontSize: 20.fSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 81.h,
            left: 48.v,
            child: Text(
              "Learning",
              style: TextStyle(
                fontSize: 50.fSize,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            width: 350.v,
            top: 140.h,
            left: 54.v,
            child: Text(
              "Here’s a list of activities that will help you master the art of orthography.",
              softWrap: true,
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
