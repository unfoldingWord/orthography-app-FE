import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/letter_assignment_screens/widgets/assign_letter_image_group.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../completion_dialog_screens/assign_letters_completion.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';
import '../../sound_groups_screens/controller/sound_groups_controller.dart';
import '../controller/letter_assignment_controller.dart';
import '../widgets/assign_signle_image_letter.dart';

/// Screen for assigning letter group images.
class AssignLetterGroupImageScreen extends StatelessWidget {

  /// GlobalKey for managing scaffold state.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Controller Declarations For Letter Assignment
  final LetterAssignmentController letterAssignmentController = Get.put(LetterAssignmentController());

  /// Controller Declarations For Sound Group
  SoundGroupsController soundGroupsController = Get.put(SoundGroupsController());

  /// Controller for managing image gallery.
  ImageGalleryController imageGalleryController = Get.put(ImageGalleryController());

  /// Focus node for managing focus.
  FocusNode focusNode = FocusNode();

  /// Scroll controller for managing scrolling behavior.
  ScrollController _scrollController = ScrollController();

  /// Arguments received by the screen.
  final Map<String, dynamic> arguments = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (imageGalleryController.isTrainingBtnSelected.value) {
          imageGalleryController.videoPlayerController?.dispose();
          Get.offAllNamed(AppRoutes.letterAssignmentGallery);
          return true;
        } else {
          Get.offAllNamed(AppRoutes.letterAssignmentGallery);
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
            title: AppbarTitle(text: 'Assign Letter'),
            actions: [SyllableHeaderAction()],
          ),
          drawer: SidebarComponentScreen(selectedVal: 5),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Obx(() {
                return SingleChildScrollView(
                  controller: letterAssignmentController.scrollController1,
                  physics: BouncingScrollPhysics(),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(height: 21.v),
                        /// Sound Group Hero Image Widget
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 18.v),
                              child: Container(
                                height: 52.h,
                                width: 52.h,
                                padding: EdgeInsets.all(10.v),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xff068CDB),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Obx((){
                                    return CustomImageView(
                                        imagePath: soundGroupsController.AllSoundGroupList
                                        [letterAssignmentController.selectedGroupIndex.value].imageUrl);
                                  })
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13.v),
                        /// Sound Group Images ListView Widget
                        GetBuilder<SoundGroupsController>(builder: (controller) {
                          var SelectedSoundGroup= soundGroupsController.AllSoundGroupList
                          [letterAssignmentController.selectedGroupIndex.value];
                          var customHeight= soundGroupsController.AllSoundGroupList
                          [letterAssignmentController.selectedGroupIndex.value].imageList.length;
                         return buildListView(SelectedSoundGroup.imageList,
                             customHeight>6?320.h:null,letterAssignmentController.scrollController2
                         );
                       }),
                       SizedBox(height: 27.v),
                        /// Previous and Next Arrow Button Widgets
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.v),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNavigationArrow(
                                isEnabled: letterAssignmentController.selectedGroupIndex > 0 &&
                                    !soundGroupsController.AllSoundGroupList[letterAssignmentController.selectedGroupIndex.value].imageList
                                        .every((element) => element.assignLetterCompleted),
                                iconPath: ImageConstant.imgRiArrowUpLine,
                                onTap: letterAssignmentController.previousGroupHandler,
                              ),
                              _buildNavigationArrow(
                                isEnabled: letterAssignmentController.selectedGroupIndex <
                                    soundGroupsController.AllSoundGroupList.length - 1 &&
                                    !soundGroupsController.AllSoundGroupList[letterAssignmentController.selectedGroupIndex.value].imageList
                                        .every((element) => element.assignLetterCompleted),
                                iconPath: ImageConstant.imgRiArrowDownLineGreenA700,
                                onTap: letterAssignmentController.nextGroupHandler,
                              ),
                            ],
                          ),
                        ),
                        /// KeyBoard Widget
                        KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                          if (isKeyboardVisible == false) {
                            focusNode.unfocus();
                          }
                          else{
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              letterAssignmentController.scrollController2.jumpTo(
                                  letterAssignmentController.scrollController2.position.maxScrollExtent);
                            });
                          }
                          return Container(
                            width: 69.0,
                            height: 76.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.h),
                              child: TextField(
                                controller: letterAssignmentController.assignLetterTextController,
                                focusNode: focusNode,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                cursorHeight: 40.h,
                                onChanged: (text) {
                                  /// Manually check the text field's length when it changes
                                  bool isTextFieldEmpty = text.isEmpty;
                                  /// Update the state to enable or disable the submit button
                                  letterAssignmentController.updateSubmitButtonState(isTextFieldEmpty);
                                },
                                style: TextStyle(fontSize: 40.fSize),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 10.v),
                        /// Module Completion dialog widget
                        Obx(() {
                            if (letterAssignmentController.isAssignmentFullyCompleted.value) {
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
                                            child: AssignLettersCompletionDialog()
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
                );
              }),
              /// Video Player Overlay Widget
              GetBuilder<ImageGalleryController>(builder: (controller) {
                return controller.isTrainingBtnSelected.value == true
                    ? Container(
                        color: Colors.black.withOpacity(0.5),
                      )
                    : Container();
              }),
              /// Video Player Overlay Widget
              WillPopScope(
                onWillPop: () async {
                  imageGalleryController.videoPlayerController?.dispose();
                  return true;
                },
                child:
                    GetBuilder<ImageGalleryController>(builder: (controller) {
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
                        : Container(); // or some other fallback widget
                  }
                }),
              )
            ],
          ),
          bottomNavigationBar:buildBottomNavigationButtonBar(context,true))
      ),
    );
  }

  Widget _buildNavigationArrow({
    required bool isEnabled,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.2,
      child: CustomIconButton(
        height: 26.adaptSize,
        width: 26.adaptSize,
        padding: EdgeInsets.all(5.h),
        child: CustomImageView(
          imagePath: iconPath,
          onTap: isEnabled ? onTap : null,
        ),
      ),
    );
  }
}
