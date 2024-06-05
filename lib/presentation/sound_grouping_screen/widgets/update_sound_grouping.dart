import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../controller/sound_grouping_controller.dart';

class UpdateSoundGroupingScreen extends StatelessWidget {
  String imgUrl;
  String imgId;

  UpdateSoundGroupingScreen(this.imgUrl,this.imgId);
  SoundGroupingController soundGroupingController = Get.put(SoundGroupingController());

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 2.v),
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.v),
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgGroup1000001986,
                    height: 13.v,
                    width: 14.h,
                    margin: EdgeInsets.only(bottom: 15.v),
                    onTap: (){
                      Get.back();
                      soundGroupingController.fetchSoundGroupsList();
                    },
                  ),
                ],),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.h,
                  vertical: 30.v,
                ),
                decoration: AppDecoration.outlineLightblue500.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder5,
                ),
                child: CustomImageView(
                  imagePath: imgUrl,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 20.v),

              /// Info Widget
              Text('If you want to move this image to another Sound Group, tap on that image below',
                  style: TextStyle(fontSize: 13.fSize,fontWeight: FontWeight.w500)),
              SizedBox(height: 20.v),

             /// Sound Groups List View
             Obx((){
               return Container(
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
                     itemCount: soundGroupingController.SoundGroupList.length + 1, // Adjusted the itemCount
                     itemBuilder: (BuildContext context, int index) {
                       if (index == 0) {
                         return Padding(
                           padding: EdgeInsets.only(right: 18.v),
                           child: InkWell(
                             onTap: (){
                               soundGroupingController.createSoundGroupUpdate(imgId, context);
                             },
                             child: Container(
                               height: 40.v,
                               width: 40.v,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 border: Border.all(
                                   color: Colors.blue,
                                   width: 1,
                                 ),
                               ),
                               child: Center(
                                 child: Icon(Icons.add, color: Colors.blue,),
                               ),
                             ),
                           ),
                         );
                       } else {
                         final int soundGroupIndex = index - 1;
                         return Padding(
                             padding: EdgeInsets.only(right: 18.v),
                             child: Obx((){
                               return InkWell(
                                 onTap: (){
                                   soundGroupingController.updateIndex(index);
                                 },
                                 child: Container(
                                   height: 50.h,
                                   width: 50.h,
                                   padding:
                                   EdgeInsets.all(10.v),
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     border: Border.all(
                                       color: soundGroupingController.selectedIndex.value == index
                                           ? Color(0xff1C8834) : Colors.orange,
                                       width: soundGroupingController.selectedIndex.value == index
                                           ? 3 : 1,
                                     ),
                                   ),
                                   child: Center(
                                     child: CustomImageView(
                                         imagePath: soundGroupingController.SoundGroupList[soundGroupIndex].imageObjectUrl),
                                   ),
                                 ),
                               );
                             })
                         );
                       }
                     },
                   ),
                 ),
               );
             }),

              /// Submit Button Widget
              Obx((){
                return Padding(
                  padding: EdgeInsets.only(top: 28.0),
                  child: soundGroupingController.isSubmitBtnEnabled==true?InkWell(
                    onTap: (){
                     var soundGroupId=soundGroupingController.SoundGroupList[soundGroupingController.selectedIndex.value - 1].
                     soundGroupId;
                      soundGroupingController.updateSoundGroup(imgId, soundGroupId, context);
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
                          )
                      ),
                    ),
                  ):
                  Opacity(
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
                          )
                      ),
                    ),
                  )
                  ,
                );
              })

            ]),

      ),);
  }

}





