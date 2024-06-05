
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../homepage_screen/controller/homepage_controller.dart';
class SidebarComponentScreen extends StatelessWidget {
  final int selectedVal;
  SidebarComponentScreen({this.selectedVal = 0,});
  /// Controllers Initialization
  final ImageGalleryController imageGalleryController = ImageGalleryController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final HomepageController controller = Get.put(HomepageController());
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    controller.fetchStatus(context);
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: Container(
            width: 301.h,
            padding: EdgeInsets.symmetric(
              horizontal: 11.h,
              vertical: 19.v,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildWidgetRow(),
                  SizedBox(height: 23.h),
                  GetBuilder<HomepageController>(builder: (controller)
                  {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.SidebarCompList.length,
                        itemBuilder: (context, index) {
                          var selectedComp = this.selectedVal;
                          return Padding(
                              padding: EdgeInsets.only(
                                  left: 8.v, right: 8.v, bottom: 8.h),
                              child: index == selectedComp ? Card(
                                elevation: 4.0,
                                color: Color(0xFF435E6F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.h),
                                  child: Container(
                                    height: 15.h,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(controller.SidebarCompList[index]['sidebaricon'],color: Colors.white,),
                                        SizedBox(width: 16.v),
                                        Text(controller.SidebarCompList[index]['title'], style: TextStyle(fontSize: 13.fSize,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ) :
                              controller.SidebarCompList[index]['isOpen']?
                              Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('btnClicked', false);
                                    prefs.setBool('isEditButtonClicked', false);
                                    ImageGalleryController imageGalleryController = Get
                                        .put(ImageGalleryController());
                                    if (imageGalleryController
                                        .isVideoInitialized.value == true) {
                                      imageGalleryController
                                          .disposeVideoPlayer();
                                    }

                                    Get.offAllNamed(controller
                                        .SidebarCompList[index]['onTap']);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12.h),
                                    child: Container(
                                      height: 15.h,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(controller
                                              .SidebarCompList[index]['sidebaricon']),
                                          SizedBox(width: 16.v),
                                          Text(controller
                                              .SidebarCompList[index]['title'],
                                            style: TextStyle(
                                                fontSize: 12.fSize,
                                                fontWeight: FontWeight
                                                    .w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )

                                  : Opacity(
                                opacity: 0.2,
                                child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: EdgeInsets.all(12.h),
                                      child: Container(
                                        height: 15.h,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(controller
                                                .SidebarCompList[index]['sidebaricon']),
                                            SizedBox(width: 16.v),
                                            Text(controller
                                                .SidebarCompList[index]['title'],
                                              style: TextStyle(
                                                  fontSize: 13.fSize,
                                                  fontWeight: FontWeight
                                                      .w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                    );
                  })
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildFoundationRow(),
        ),
      ),
    );
  }


  Widget _buildWidgetRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 70.h,
              width: 70.v,
              child:
              Stack(alignment: Alignment.bottomCenter, children: [
                CustomImageView(
                    imagePath: ImageConstant.imgOrthographyLog,
                    height: 87.adaptSize,
                    width: 87.adaptSize,
                    alignment: Alignment.center),
                CustomImageView(
                    imagePath: ImageConstant.imgEllipse5,
                    height: 1.v,
                    width: 49.h,
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 11.v))
              ])),
          CustomImageView(
            imagePath: ImageConstant.imgGroup1000001986,
            height: 13.v,
            width: 14.h,
            margin: EdgeInsets.only(bottom: 39.v),
            onTap: (){
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoundationRow() {
    return Padding(
      padding:EdgeInsets.all(16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: () async {
            Future.delayed(
              Duration(milliseconds: 500),
                  () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    Get.offAllNamed(
                      AppRoutes.loginScreen,
                    );
              },
            );

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgElOff,
                height: 23.v,
                width: 24.h,
                margin: EdgeInsets.only(bottom: 1.v),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 6.h,
                  top: 3.v,
                ),
                child: Text(
                  "lbl_logout".tr,
                  style: CustomTextStyles.titleMediumRedA700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
