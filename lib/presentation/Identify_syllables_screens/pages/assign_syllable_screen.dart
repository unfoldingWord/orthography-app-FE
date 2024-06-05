import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/assign_syllable_screen_widgets/aasign_syllable_body_widget.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/assign_syllable_screen_widgets/assign_syllable_bottom_navigation.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/controller/expanded_view_controller.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';

class AssignSyllableScreen extends StatelessWidget {
  /// Controller for managing expanded view
  final ExpandedViewController controller = Get.put(ExpandedViewController());
  /// Key for managing the state of the scaffold widget
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  /// Controller for managing image gallery operations
  ImageGalleryController imageGalleryController = Get.put(ImageGalleryController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        imageGalleryController.imageGalleryList.value.clear();
        imageGalleryController.currentPage.value=1;
        imageGalleryController.fetchImages(context, page: imageGalleryController.currentPage.value);
        /// Handling the back button press event
        if (imageGalleryController.isTrainingBtnSelected.value) {
          /// If training video is selected, dispose the video player and navigate back to the syllables screen
          imageGalleryController.videoPlayerController?.dispose();
          imageGalleryController.updateVideoStatus(false);
          Get.offAllNamed(AppRoutes.identifySyllablesScreen);
          return true;
        } else {
          /// If training video is not selected, simply navigate back
          imageGalleryController.textController.text = '0';
          imageGalleryController.shouldKeyPad.value=false;
          Get.back();
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: scaffoldKey,
          appBar: AppBar(
            leadingWidth: 45.h,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: AppbarTitle(text: 'Identify Syllables'),
            actions: [SyllableHeaderAction()], /// Header actions for syllables screen
          ),
          drawer: SidebarComponentScreen(selectedVal: 1), // Sidebar drawer
          body: Stack(
            fit: StackFit.expand,
            children: [
              /// Main syllable widget
              SyllableWidget(),
              /// Video Overlay Widget
              GetBuilder<ImageGalleryController>(builder: (controller) {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                  color: Colors.black.withOpacity(0.5),
                )
                    : Container();
              }),
              /// Overlay Video Player Widget
              WillPopScope(
                onWillPop: () async {
                  /// Dispose video player when navigating back
                  imageGalleryController.videoPlayerController?.dispose();
                  return true;
                },
                child: GetBuilder<ImageGalleryController>(
                  builder: (controller) {
                    if (controller.isTrainingBtnSelected.value == false) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: controller.isTrainingBtnSelected.value == false
                              ? Colors.transparent
                              : Colors.white,
                        ),
                      );
                    } else {
                      return (controller.chewieController != null)
                          ? Chewie(controller: controller.chewieController!)
                          : Container();
                    }
                  },
                ),
              )
            ],
          ),
          bottomNavigationBar: SyllableBottomNavigation(), /// Bottom navigation bar for syllables screen
        ),
      ),
    );
  }
}
