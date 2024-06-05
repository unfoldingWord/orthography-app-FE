import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../completion_dialog_screens/assign_letters_data_lost_dialog.dart';
import '../../sound_groups_screens/controller/sound_groups_controller.dart';
import '../controller/letter_assignment_controller.dart';

/// Widget to build the list of images
Widget buildSoundGroupImgList(dynamic list, soundGrpUrl,soundGrpId) {
  LetterAssignmentController controller = Get.find<LetterAssignmentController>();
  return Align(
    alignment: Alignment.centerRight,
    child: SizedBox(
      height: 100.v,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 23.h),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(width: 15.h);
        },
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              controller.updateImgIndex(index);
              controller.assignSelectedGalleryList(list);
              /// Navigate to assign grapheme screen
              if(list[index].assignLetterCompleted==true)
                {

                }else{
                Get.toNamed(
                  AppRoutes.assignLetterSingleImage,
                  arguments: {
                    'imageUrl':  list[index].imageObjectUrl,
                    'imageId':  list[index].imageId,
                    'syllableType': list[index].syllableType,
                    'soundGrpUrl': soundGrpUrl,
                    'list':list,
                    'soundGrpId':soundGrpId
                  },
                );
              }

            },
            child: SizedBox(
              width: 90.h,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.v),
                  child: Container(
                    height: 100.v,
                    width: 90.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.h,
                      vertical: 9.v,
                    ),
                    decoration: AppDecoration.outlineLightblue500.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),

                    child: Stack(
                      children: [
                        list[index].assignLetterCompleted
                            ? Positioned(
                          top: -2.v,
                          right: 0,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgCheckmark,
                            alignment: Alignment.topRight,
                            height: 20.h,
                            width: 20.v,
                          ),
                        )
                            : Container(),
                        Positioned(
                          child: CustomImageView(
                            imagePath: list[index].imageObjectUrl,
                            alignment: Alignment.center,
                            width: 40.v,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

/// Widget to build the row for assigning symbols
Widget buildAssignSymbolRow({
  required String assignSymbol,
  required String imgUrl,
  required imageIdsList,
  index,
  required BuildContext context,
  required isLetterAssigned,
}) {
  /// Letter Assignment Controller
  LetterAssignmentController allSoundGroupsController = Get.put(LetterAssignmentController());
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(bottom: 6.v),
        child: Container(
          height: 50.h,
          width: 50.h,
          padding: EdgeInsets.all(10.v),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xffEF802F),
              width: 1,
            ),
          ),
          child: Center(
            child: CustomImageView(
              imagePath: imgUrl,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 40.v),
        child: InkWell(
          onTap: () {
            allSoundGroupsController.updateGroupIndex(index);
            allSoundGroupsController.updateImgIdsList(imageIdsList.toList());
            if (isLetterAssigned) {
              showDialog<void>(
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
                        child: AssignLettersDataLostDialog(
                          imageIdsList: imageIdsList,
                          index: index,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              /// Navigate to assign group grapheme screen
              Get.toNamed(
                AppRoutes.assignGroupLetterScreen,
                arguments: {
                  'selectedGraphemeIndex': index,
                  'ImgIdsList': imageIdsList,
                },
              );
            }
          },
          child: Text(
            assignSymbol,
            style: theme.textTheme.labelLarge!.copyWith(
              color: appTheme.blue500,
            ),
          ),
        ),
      ),
    ],
  );
}

