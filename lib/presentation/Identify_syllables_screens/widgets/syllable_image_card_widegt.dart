
import 'package:flutter/cupertino.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../core/utils/image_constant.dart';
import '../../../widgets/custom_image_view.dart';

class ImageCard extends StatelessWidget {
  final dynamic cardDetails;

  /// Constructor to initialize cardDetails
  ImageCard({required this.cardDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.v,
      width: 190.h,
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 9.v),
      decoration: AppDecoration.outlineLightblue500.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: cardDetails.completed
          ? Stack(
              children: [
                /// Checkmark icon positioned at the top right
                Positioned(
                  top: 0,
                  right: 0,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgCheckmark,
                    alignment: Alignment.topRight,
                    height: 20.h,
                    width: 20.v,
                  ),
                ),

                /// Image positioned below the checkmark
                Positioned(
                  top: 20,
                  left: 10,
                  child: CustomImageView(
                    imagePath: cardDetails.fileUrl,
                    alignment: Alignment.center,
                    height: 60.adaptSize,
                    width: 60.adaptSize,
                  ),
                ),
              ],
            )

          /// Widget for incomplete images
          : SizedBox(
              height: 58.h,
              width: 59.v,
              child: CustomImageView(
                imagePath: cardDetails.fileUrl,
                alignment: Alignment.center,
              ),
            ),
    );
  }
}
