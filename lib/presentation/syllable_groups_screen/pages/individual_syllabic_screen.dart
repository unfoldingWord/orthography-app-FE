import 'package:chewie/chewie.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/expanded_view_controller.dart';
import '../widgets/update_syllable_screen.dart';


class IndividualSyllabicList extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomepageController homepageController = HomepageController();
  final ExpandedViewController expandedViewController = Get.put(ExpandedViewController());
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    expandedViewController.updateSyllableType(arguments['number']);
    mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (controller.isTrainingBtnSelected.value) {
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {

          // Get.offAllNamed(AppRoutes.syllableGroupsScreen);
          Get.back();
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                leadingWidth: 45.h,
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: AppbarTitle(text:'${arguments['syllableType']} Syllable Group'),
                actions: [
                  SyllableHeaderAction()
                ]
            ),
            drawer: SidebarComponentScreen(selectedVal: 2,),
            body: Obx((){
              return
                Skeletonizer(
                  enabled: controller.isLoading.value,
                child:
                Stack(
                    fit: StackFit.expand,
                    children:
                    [
                      SizedBox(
                          child: SingleChildScrollView(
                              padding: EdgeInsets.only(top: 54.v),
                              child: _buildSyllabicList()
                          )),
                      /// Training video Overlay Widget
                      Obx(() {
                        return controller.isTrainingBtnSelected.value == true
                            ? Container(
                          color: Colors.black.withOpacity(0.5), // Set opacity as needed
                        )
                            : Container();
                      }),
                      /// Training video Overlay Widget
                      WillPopScope(
                        onWillPop: () async {
                          controller.videoPlayerController?.dispose();
                          return true;
                        },
                        child:
                        GetBuilder<ImageGalleryController>(builder: (controller) {
                          if (controller.isTrainingBtnSelected.value == false) {
                            return Obx(() {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: controller.isTrainingBtnSelected.value == false
                                      ? Colors.transparent
                                      : Colors.white,
                                ),
                              );
                            });
                          } else {
                            return (controller.chewieController != null)
                                ? Chewie(controller: controller.chewieController!)
                                : Container(); // or some other fallback widget
                          }
                        }),
                      )
                    ])
                );

            })

        ),
      ),
    );
  }

  /// Syllabic Image Listview
  Widget _buildSyllabicList() {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 90.v,
          crossAxisCount: 3,
          mainAxisSpacing: 23.h,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: expandedViewController.syllabiclistItemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // onTapAPPOINTMENT!.call();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 12.v, right: 12.v,bottom: 5.v),
              child: Container(
                height: 100.v,
                width: 90.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.h,
                  vertical: 9.v,
                ),
                decoration: AppDecoration.outlineLightblue500.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder5,
                ),
                child: Obx(
                      () => InkWell(
                        splashColor: Colors.grey,
                    onTap: (){
                      expandedViewController.selectedImgIndex.value=index;
                      Get.toNamed(AppRoutes.syllabicExpandedViewScreen,
                          arguments: {
                            'syllableType':arguments['syllableType'],
                            'number':1
                          }
                      );
                    },
                    onLongPress: (){
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: UpdateSyllable(
                              imageUrl:expandedViewController.syllabiclistItemList[index].imageObjectUrl ,
                              imageId: expandedViewController.syllabiclistItemList[index].imageId,
                              typee: arguments['syllableType'],
                            ),
                          );
                        },
                      );
                    },
                    child: CustomImageView(
                      imagePath: expandedViewController.syllabiclistItemList[index].imageObjectUrl,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

}



