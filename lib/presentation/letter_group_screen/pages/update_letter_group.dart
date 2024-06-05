import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/letter_group_screen/controller/letter_group_controller.dart';
import '../../letter_assignment_screens/controller/letter_assignment_controller.dart';

class UpdateLetterGroupScreen extends StatelessWidget {
  String imageUrl;
  String imageId;

  /// Constructor
  UpdateLetterGroupScreen({required this.imageUrl, required this.imageId});

  /// Controller for managing letter assignments
  final LetterAssignmentController letterAssignmentController = Get.put(LetterAssignmentController());

  /// Instance of LetterGroupsController
  LetterGroupsController letterGroupsController = LetterGroupsController();

  @override
  Widget build(BuildContext context) {
    /// Update image ID list
    letterAssignmentController.updateImgIdsList([imageId]);
    mediaQueryData = MediaQuery.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 2.v),
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.v),
        child: Column(
          children: [
            /// Custom back button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup1000001986,
                  height: 13.v,
                  width: 14.h,
                  margin: EdgeInsets.only(bottom: 15.v),
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
            /// Display image
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 45.h,
                vertical: 65.v,
              ),
              decoration: AppDecoration.outlineLightblue500.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder5,
              ),
              child: CustomImageView(
                imagePath: imageUrl,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 20.v),
            /// Instruction text
            Text(
              'If you want to assign a different letter to this image, tap on that letter below',
              style: TextStyle(fontSize: 13.fSize, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20.v),
            /// Grid view of letters for assignment
            Container(
              height: 150.h,
              width: double.maxFinite,
              child: Scrollbar(
                isAlwaysShown: true,
                radius: Radius.circular(10),
                thickness: 5,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2.v,
                    mainAxisSpacing: 5.h,
                  ),
                  itemCount: letterGroupsController.alphabets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 18.v),
                      child: Obx(() {
                        return GestureDetector(
                          onTap: () {
                            letterGroupsController.updateIndex(index);
                            letterAssignmentController
                                .updateLetterTextField(letterGroupsController.alphabets[index]);
                          },
                          child: Container(
                            height: 40.v,
                            width: 40.v,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: letterGroupsController.selectedIndex == index
                                  ? Color(0xffEF802F)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.orange,
                                width: 1,
                              ),
                            ),
                            child: Obx(() {
                              return Center(
                                child: Text(
                                  '${letterGroupsController.alphabets[index]}',
                                  style: TextStyle(
                                    color: letterGroupsController.selectedIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 26.fSize,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
            /// Submit Button Widget
            Obx(() {
              return letterGroupsController.selectedIndex == -1
                  ? Padding(
                padding: EdgeInsets.only(top: 28.0),
                child: Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 117.v,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xff435E6F),
                    ),
                    child: Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 12.fSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(top: 28.0),
                child: InkWell(
                  onTap: () {
                    letterAssignmentController
                        .handleAssignLetters(context, true)
                        .whenComplete(() {
                      Get.offAllNamed(AppRoutes.letterGroupsScreen);
                    });
                  },
                  child: Container(
                    width: 117.v,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xff435E6F),
                    ),
                    child: Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 12.fSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
