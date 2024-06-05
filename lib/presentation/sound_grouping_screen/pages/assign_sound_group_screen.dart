import 'package:chewie/chewie.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/assign_image_list_widget.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/image_preview_widget.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/sound_grp_skip_image_widget.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/bottom_navigation_widget.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/custom_floating_action_button.dart';
import 'package:orthoappflutter/presentation/sound_grouping_screen/widgets/sound_grp_list_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../syllable_groups_screen/controller/expanded_view_controller.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/sound_grouping_controller.dart';

class AssignSoundGroupScreen extends StatelessWidget {
  /// Initialize controllers and variables
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomepageController homepageController = HomepageController();
  final SoundGroupingController soundGroupController = Get.put(SoundGroupingController());
  final ExpandedViewController expandedViewController = ExpandedViewController();
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    /// Update syllable type and group status
    expandedViewController.updateSyllableType(arguments['number']);
    soundGroupController.updateGrpStatus();
    return WillPopScope(
      onWillPop: () async {
        return _handleWillPop(context);
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: true,
          /// AppBar Component
          appBar: AppBar(
            leadingWidth: 45.h,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: AppbarTitle(text: 'Sound Grouping'),
            actions: [SyllableHeaderAction()],
          ),
          /// SideBar Component
          drawer: SidebarComponentScreen(selectedVal: 3),
          body: Obx(() {
            return Skeletonizer(
              enabled: controller.isLoading.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildBody(context),
                  /// Video Overlay Widget
                  Obx(() {
                    return controller.isTrainingBtnSelected.value == true
                        ? Container(
                      color: Colors.black.withOpacity(0.5),
                    )
                        : Container();
                  }),
                  /// Video Overlay Widget
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
                          return (controller.chewieController != null)
                              ? Chewie(controller: controller.chewieController!)
                              : Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          }),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
          floatingActionButton: Opacity(
            opacity: 0.2,
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 1.0),
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/bi_mic-fill.svg',
                    height: 32,
                    width: 32,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SoundGroupingBottomNavigationWidget(),
        ),
      ),
    );
  }

  /// Assign Sound Group Body Widget
  Widget _buildBody(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 21.v, bottom: 5.v),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 21.v),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5.v),
                  child: Column(
                    children: [
                      SoundGrpImagePreview(SyllableType: arguments['syllableType']),
                      SizedBox(height: 13.v),
                      SoundGrpSkipImg(),
                      SizedBox(height: 25.h),
                      SoundGrpList(),
                      SizedBox(height: 25.h),
                      soundGroupController.SoundGroupImagesList.length > 4
                          ? Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            var soundGrpImg = soundGroupController.SoundGroupImagesList[
                              soundGroupController.SoundGroupImagesList.length-1].imageObjectUrl;
                            Get.toNamed(
                              AppRoutes.seeMoreSoundGroupingScreen,
                              arguments: {
                                'soundGroupImg':soundGrpImg,
                                'soundGroupList': soundGroupController.SoundGroupImagesList,
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 3.v, right: 20.v),
                            child: Text(
                              'See More',
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                      )
                          : Container(),
                      SoundGrpImages(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Method to handle back navigation
  bool _handleWillPop(BuildContext context) {
    if (controller.isTrainingBtnSelected.value) {
      controller.videoPlayerController?.dispose();
      controller.updateVideoStatus(false);
      return false;
    } else {
      Get.offAllNamed(AppRoutes.soundGroupGalleryScreen);
      return true;
    }
  }
}
