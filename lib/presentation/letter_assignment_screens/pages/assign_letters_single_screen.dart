import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/Identify_syllables_screens/widgets/syllable_header_actions_widget.dart';
import 'package:orthoappflutter/presentation/letter_assignment_screens/widgets/assign_signle_image_letter.dart';
import 'package:orthoappflutter/widgets/app_bar/appbar_title.dart';
import '../../Identify_syllables_screens/controller/image_gallery_controller.dart';
import '../../completion_dialog_screens/assign_letters_completion.dart';
import '../../completion_dialog_screens/letter_assignment_single_sound_grp.dart';
import '../../sidebar_component_screen/sidebar_component_screen.dart';
import 'package:flutter/material.dart';
import '../controller/letter_assignment_controller.dart';

/// Screen for assigning a single letter image.
class AssignLetterSingleImage extends StatelessWidget {
  /// Declaration Of Letter Assignment Controller
  final LetterAssignmentController letterAssignmentController = Get.put(LetterAssignmentController());

  /// GlobalKey for managing scaffold state.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
    letterAssignmentController.updateImgIdsList([arguments['imageId']]);
    letterAssignmentController.updateSelectedSoundGrpId(arguments['soundGrpId'], arguments['soundGrpUrl']);

    return WillPopScope(
      onWillPop: () async {
        if (imageGalleryController.isTrainingBtnSelected.value) {
          imageGalleryController.videoPlayerController?.dispose();
          imageGalleryController.updateVideoStatus(false);
          return false;
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
                  print(letterAssignmentController.selectedImgIndex.value);
                  print(letterAssignmentController.assignSelectedGalleryList.length);
                  print(letterAssignmentController.selectedImgIndex.value <
                      letterAssignmentController.assignSelectedGalleryList.length);
                  if (letterAssignmentController.assignSelectedGalleryList.isNotEmpty &&
                      letterAssignmentController.selectedImgIndex.value <
                      letterAssignmentController.assignSelectedGalleryList.length) {
                    var SelectedSoundGroup = letterAssignmentController.assignSelectedGalleryList[
                                              letterAssignmentController.selectedImgIndex.value];
                    return SingleChildScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            SizedBox(height: 21.v),

                            /// Image Preview Widget
                            buildImgPreviewWidget(
                              context,
                              SelectedSoundGroup.imageObjectUrl,
                            ),
                            SizedBox(height: 13.v),

                            /// Skip Image Widget
                            Align(
                              alignment: Alignment.centerRight,
                              child: GetBuilder<ImageGalleryController>(
                                builder: (controller) {
                                  return InkWell(
                                    onTap: () {
                                      /// Calling Skip Image Api
                                      letterAssignmentController.skipImage(
                                          context, SelectedSoundGroup.imageId);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 22.h),
                                      child: Text(
                                        "lbl_skip".tr,
                                        style: CustomTextStyles
                                            .titleMediumBlueA400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 27.v),

                            /// Syllable Group widget
                            Obx(() {
                              var name = letterAssignmentController
                                  .capitalizeFirstWord(
                                      letterAssignmentController.assignSelectedGalleryList
                                      [letterAssignmentController.selectedImgIndex.value].syllableType);

                              return buildContainer(
                                  'Syllable Group -', '${name} Syllabic');
                            }),
                            SizedBox(height: 10.v),

                            /// Sound Group
                            buildContainer(
                              'Sound Group -',
                              '',
                              imagePath: arguments['soundGrpUrl'],
                            ),
                            SizedBox(height: 30.v),

                            /// Text Input Field Widget
                            KeyboardVisibilityBuilder(
                                builder: (context, isKeyboardVisible) {
                              if (isKeyboardVisible == false) {
                                focusNode.unfocus();
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.h),
                                  child: TextField(
                                    controller: letterAssignmentController
                                        .assignLetterTextController,
                                    focusNode: focusNode,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z]')),
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    onChanged: (text) {
                                      /// Manually check the text field's length when it changes
                                      bool isTextFieldEmpty = text.isEmpty;

                                      /// Update the state to enable or disable the submit button
                                      letterAssignmentController.updateSubmitButtonState(isTextFieldEmpty);
                                    },
                                    cursorHeight: 40.h,
                                    style: TextStyle(fontSize: 40.fSize),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(height: 10.v),

                            /// Single Sound Group Completion dialog widget
                            Obx(
                              () {
                                if (letterAssignmentController
                                    .isSGAssignmentCompleted.value) {
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
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            content: Container(
                                                child: LetterAssignSingleSoundCompletionDialog(
                                                    ImageUrl:
                                                        letterAssignmentController
                                                            .selectedSoundGrpURL
                                                            .value)),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                                return SizedBox.shrink();
                              },
                            ),

                            /// Module Completion dialog widget
                            Obx(
                              () {
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
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            content: Container(
                                                child:
                                                    AssignLettersCompletionDialog()),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    /// Return a placeholder widget or handle the error appropriately
                    return Center(
                        child: Text('No data or index out of bounds'));
                  }
                }),

                /// Video Player Overlay
                GetBuilder<ImageGalleryController>(
                  builder: (controller) {
                    return controller.isTrainingBtnSelected.value == true
                        ? Container(
                            color: Colors.black.withOpacity(0.5),
                          )
                        : Container();
                  },
                ),

                /// Video Player Overlay
                WillPopScope(
                  onWillPop: () async {
                    imageGalleryController.videoPlayerController?.dispose();
                    return true;
                  },
                  child: GetBuilder<ImageGalleryController>(
                    builder: (controller) {
                      if (controller.isTrainingBtnSelected.value == false) {
                        return Center(
                          child: CircularProgressIndicator(
                            color:
                                controller.isTrainingBtnSelected.value == false
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
                ),
              ],
            ),
            bottomNavigationBar: buildBottomNavigationButtonBar(context, false)

            /// Bottom navigation Button widget
            ),
      ),
    );
  }
}
