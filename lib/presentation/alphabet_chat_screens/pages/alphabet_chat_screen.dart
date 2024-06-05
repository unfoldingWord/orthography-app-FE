import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/sidebar_component_screen/sidebar_component_screen.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import '../../completion_dialog_screens/download_completion_dialog.dart';
import '../../letter_group_screen/controller/letter_group_controller.dart';
import '../controller/alphabet_chat_controller.dart';

class AlphabetChatScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final AlphabetChartController alphabetChartController = Get.put(AlphabetChartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LetterGroupsController letterGroupsController=Get.put(LetterGroupsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isTrainingBtnSelected.value) {
          controller.videoPlayerController?.dispose();
          controller.updateVideoStatus(false);
          return false;
        } else {
          Get.offAllNamed(AppRoutes.homepageOneScreen);
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
              title: AppbarTitle(text:"Alphabet Set"),
              actions: [
                SyllableHeaderAction()
              ]
          ),
          drawer: SidebarComponentScreen(selectedVal: 7),
          body: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16.v),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 30.v),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: (){
                              alphabetChartController.fetchExportLink(context);
                            },
                            child: Container(
                              width: 105.v,
                              height: 35.h,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgIcRoundDownload,
                                    height: 14.v,
                                    width: 15.h,
                                  ),
                                  Text('Download',style: TextStyle(color: Colors.green,fontSize: 14.fSize,
                                      fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.v),
                      /// Alphabet List Widget
                      _buildAlphabetGridView(),
                      /// Download Successfully Dialog Widget
                      Obx(
                            () {
                          if (alphabetChartController.isLoading.value) {
                            Future.delayed(Duration.zero, () {
                              return showDialog<void>(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      /// Return false to prevent the dialog from closing
                                      return false;
                                    },
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      content: Container(
                                          child: DownloadCompletionDialog()
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                          }
                          return SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                ),
              ),
              Obx(() {
                return alphabetChartController.isLoading.value
                    ? Container(
                  color: Colors.black.withOpacity(0.5), /// Set opacity
                )
                    : Container();
              }),

              Obx(() {
                return alphabetChartController.isLoading.value
                    ?Center(
                  child: CircularProgressIndicator(
                    color: controller.isTrainingBtnSelected.value == false
                        ? Colors.transparent
                        : Colors.white,
                  ),
                )
                    : Container();
              }),

              /// Video overlay widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                  color: Colors.black.withOpacity(0.5), // Set opacity as needed
                )
                    : Container();
              }),
              /// Video player overlay
              WillPopScope(
                onWillPop: () async {
                  controller.videoPlayerController?.dispose();
                  return true;
                },
                child: GetBuilder<ImageGalleryController>(builder: (controller) {
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
                    return Chewie(controller: controller.chewieController);
                  }
                }),
              ),
            ],
          )


        ),
      ),
    );
  }

  Widget _buildAlphabetGridView() {
    return Obx((){
      letterGroupsController.letterGalleryList.sort((a, b) => a.letter.compareTo(b.letter));
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 99.v,
            crossAxisCount: 3,
            mainAxisSpacing: 13.h,
            crossAxisSpacing: 13.h,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: letterGroupsController.letterGalleryList.length,
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  Get.toNamed(
                      AppRoutes.seeMoreLettersGroupsScreen,
                      arguments: {
                        'letter': letterGroupsController.letterGalleryList[index].letter,
                      }
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.h,
                    vertical: 30.v,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x1917396B),
                            spreadRadius: 2.h,
                            blurRadius: 2.h,
                            offset: Offset(1.34, 0)
                        )
                      ]
                  ),
                  child:  Text(
                      letterGroupsController.letterGalleryList[index].letter,
                      style: TextStyle(fontSize: 30.fSize,fontWeight: FontWeight.w500)
                  ),
                ),
              ),
            );
          },
        ),

      );
    });
  }
}
