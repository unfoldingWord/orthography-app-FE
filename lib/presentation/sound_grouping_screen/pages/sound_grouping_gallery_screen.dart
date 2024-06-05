import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/controller/syllable_groups_controller.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/controller/sound_grouping_controller.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/syllabic_image_row_widget.dart';
import 'package:orthoappflutter/presentation/sidebar_component_screen/sidebar_component_screen.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';

class SoundGroupGalleryScreen extends StatelessWidget {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SyllableGroupsController syllableGroupsController = Get.put(SyllableGroupsController());
  final SoundGroupingController soundGroupingController = Get.put(SoundGroupingController());

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
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
            title: AppbarTitle(text: "Sound Group Gallery"),
            actions: [SyllableHeaderAction()],
          ),
          drawer: SidebarComponentScreen(selectedVal: 3),
          body: Stack(
            fit: StackFit.expand,
            children: [
              GetBuilder<SoundGroupingController>(builder: (controller) {
                if (soundGroupingController.isPrefsInitialized == false) {
                  return Center(
                    child: Container(),
                  );
                } else {
                  return Skeletonizer(
                    enabled: syllableGroupsController.isLoading.value,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 22.v, top: 39.v, right: 26.v),
                      child: Column(
                        children: [
                          /// Mono Syllabic Row
                          SyllabicImageRow(
                            SyllabicName: 'Mono',
                            SyllabicNumber: 1,
                            SyllabicList: syllableGroupsController.Monosyllables,
                            isSyllabicCompleted: soundGroupingController.prefs!.getBool('isMonoCompleted'),
                          ),
                          SizedBox(height: 37.v),
                          /// Bi Syllabic Row
                          SyllabicImageRow(
                            SyllabicName: 'Bi',
                            SyllabicNumber: 2,
                            SyllabicList: syllableGroupsController.Bisyllables,
                            isSyllabicCompleted: soundGroupingController.prefs!.getBool('isBiGrpCompleted'),
                          ),
                          SizedBox(height: 37.v),
                          /// TRI Syllabic Row
                          SyllabicImageRow(
                            SyllabicName: 'Tri',
                            SyllabicNumber: 3,
                            SyllabicList: syllableGroupsController.Trisyllables,
                            isSyllabicCompleted: soundGroupingController.prefs!.getBool('isTriGrpCompleted'),
                          ),
                          SizedBox(height: 37.v),
                          /// Poly Syllabic Row
                          SyllabicImageRow(
                            SyllabicName: 'Poly',
                            SyllabicNumber: 4,
                            SyllabicList: syllableGroupsController.Polysyllables,
                            isSyllabicCompleted: soundGroupingController.prefs!.getBool('isPolyGrpCompleted'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
              /// Video Overlay Widget
              Obx(() {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                  color: Colors.black.withOpacity(0.5),
                )
                    : Container();
              }),
              /// Video Player Widget
              WillPopScope(
                onWillPop: () async {
                  controller.videoPlayerController?.dispose();
                  return true;
                },
                child: GetBuilder<ImageGalleryController>(
                  builder: (controller) {
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
