import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/controller/syllable_groups_controller.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/widgets/syllabic_button_widget.dart';

class UpdateSyllable extends StatelessWidget {
  final String? imageUrl;
  final String? imageId;
  final String? typee;

  UpdateSyllable({this.imageUrl, this.imageId, this.typee});
  SyllableGroupsController syllableGroupsController = SyllableGroupsController();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 2.v),
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.v),
        child: Column(
          children: [
            /// Close Icon Widget
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
            /// Image Preview Widget
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
                width: 139.v,
                height: 160.h,
              ),
            ),
            SizedBox(height: 20.v),
            Text(
              'Move this image into another Syllable Group by selecting one of these -',
              style: TextStyle(fontSize: 13.fSize, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20.v),
            /// Syllabic Button Widget Based on Syllabic Type
            SyllabicButtonWidget(syllabicType: typee!, imageId: imageId!),
          ],
        ),
      ),
    );
  }
}
