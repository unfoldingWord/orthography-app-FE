import 'package:chewie/chewie.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/letter_assignment_screens/widgets/letter_assigmnet_widgets.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import '../../sound_groups_screens/controller/sound_groups_controller.dart';
import '../controller/letter_assignment_controller.dart';
import 'package:flutter/material.dart';

/// Screen for displaying the letter assignment gallery.
class LetterAssignmentGallery extends StatelessWidget {
  /// Controller for managing the image gallery.
  final ImageGalleryController controller = Get.put(ImageGalleryController());

  /// Controller for managing all sound groups.
  final LetterAssignmentController letterAssignmentController = Get.put(LetterAssignmentController());

  final SoundGroupsController soundGroupsController = Get.put(SoundGroupsController());

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
          appBar: AppBar(
            leadingWidth: 45.h,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: AppbarTitle(text: "Assign Letter Gallery"),
            actions: [SyllableHeaderAction()],
          ),
          drawer: SidebarComponentScreen(selectedVal: 5),
          body: SizedBox(
              child: Stack(
            fit: StackFit.expand,
            children: [
              /// Main body content
              SingleChildScrollView(
                  padding: EdgeInsets.only(top: 6.v),
                  child: Obx(() {
                    return Wrap(
                      spacing: 5.h,
                      children: List.generate(
                        soundGroupsController.AllSoundGroupList.length,
                        (index) {
                          var imgUrl = soundGroupsController.AllSoundGroupList[index].imageUrl;
                          var list = soundGroupsController.AllSoundGroupList[index].imageList;
                                     letterAssignmentController.updateGalleryList(list);
                          var imageIdsList = list.map((e) => e.imageId);
                          var isLetterAssigned = list.any((element) => element.assignLetterCompleted == true);
                          var soundGrpId = soundGroupsController.AllSoundGroupList[index].id;
                          return list.length==0?Container():Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.h),
                                child: buildAssignSymbolRow(
                                    assignSymbol: "+ Assign Letter",
                                    imgUrl: imgUrl,
                                    imageIdsList: imageIdsList,
                                    index: index,
                                    context: context,
                                    isLetterAssigned: isLetterAssigned),
                              ),
                              SizedBox(height: 9.v),
                              buildSoundGroupImgList(list, imgUrl, soundGrpId),
                              SizedBox(height: 32.v),
                            ],
                          );
                        },
                      ),
                    );
                  })
              ),

              /// Video Overlay Widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                        color: Colors.black
                            .withOpacity(0.5), // Set opacity as needed
                      )
                    : Container();
              }),

              /// Video Overlay Widget
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
                    return Chewie(controller: controller.chewieController);
                  }
                }),
              )
            ],
          )),
        ),
      ),
    );
  }
}
