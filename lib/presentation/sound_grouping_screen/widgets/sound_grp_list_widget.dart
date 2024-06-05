
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../syllable_groups_screen/controller/expanded_view_controller.dart';
import '../controller/sound_grouping_controller.dart';

class SoundGrpList extends StatelessWidget {
  final SoundGroupingController soundGroupController = Get.put(SoundGroupingController());

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 18.v),
        child: Row(
          children: [
            GetBuilder<ExpandedViewController>(
              builder: (controller) {
                return InkWell(
                  splashColor: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    /// Create a new sound group
                    var controllerData = controller.syllabiclistItemList[soundGroupController.previewImageIndex.value];
                    var imgId = controllerData.imageId;
                    var imgUrl = controllerData.imageObjectUrl;
                    var languageId = controllerData.languageId;
                    var userId = controllerData.userId;
                    var id = controllerData.id;
                    soundGroupController.createSoundGroup(imgId,imgUrl, languageId, userId, id, context);
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    padding: EdgeInsets.all(10.v),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),

            /// Sound Group List From API
            Expanded(child:  Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: 13.v, right: 23.v),
                child: Wrap(
                    spacing: 13.v,
                    children: List.generate(
                      soundGroupController.SoundGroupList.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {},
                          child: GetBuilder<ExpandedViewController>(
                            builder: (controller) {
                              return InkWell(
                                onTap: () {
                                  /// Update the selected index and other details
                                  var imgId = controller
                                      .syllabiclistItemList[soundGroupController.previewImageIndex.value]
                                      .imageId;
                                  var imgUrl = controller
                                      .syllabiclistItemList[soundGroupController.previewImageIndex.value]
                                      .imageObjectUrl;
                                  var languageId = controller
                                      .syllabiclistItemList[soundGroupController.previewImageIndex.value]
                                      .languageId;
                                  var userId = controller
                                      .syllabiclistItemList[soundGroupController.previewImageIndex.value]
                                      .userId;
                                  var id = controller
                                      .syllabiclistItemList[soundGroupController.previewImageIndex.value]
                                      .id;
                                  soundGroupController.selectedSoundGrpUrl.value=imgUrl!;
                                  soundGroupController.updateSelectedIndex(
                                      index, imgId, imgUrl, languageId, userId, id);
                                },
                                child: Obx(() {
                                  return Container(
                                    height: 50.h,
                                    width: 50.h,
                                    padding: EdgeInsets.all(10.v),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: soundGroupController.selectedIndex.value == index
                                            ? Color(0xff1C8834)
                                            : Colors.orange,
                                        width: soundGroupController.selectedIndex.value == index ? 3 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomImageView(
                                        imagePath: soundGroupController.SoundGroupList[index].imageObjectUrl,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        );
                      },
                    ).toList()
                ),
              ),
            )))
            ,
          ],
        ),
      )

    );
  }
}
