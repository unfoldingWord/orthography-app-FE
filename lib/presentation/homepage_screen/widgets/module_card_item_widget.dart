
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/homepage_screen/widgets/progress_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This widget represents an item card for a module in the homepage.
class ModuleItemCard extends StatelessWidget {
  final dynamic cardData;

  /// Constructor to initialize the card data.
  ModuleItemCard({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('btnClicked', false);
          prefs.setBool('isEditButtonClicked', false);
          /// Navigate to the specified route when the card is tapped.
          Get.toNamed(cardData['onTap']);

        },
        child: Padding(
          padding: EdgeInsets.all(26.h),
          child: Container(
            height: 32.h,
            child: Row(
              children: [
                /// Container for the module icon.
                Container(
                  width: 50.v,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Color(0xFF3081AC),
                      width: 2.0, // Outline width
                    ),
                  ),
                  child: Center(child: SvgPicture.asset(cardData['icon'])),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Display the title of the module.
                      Padding(
                        padding: EdgeInsets.all(6.h),
                        child: Text(
                          cardData['title'],
                          style: TextStyle(
                              fontSize: 15.fSize, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                /// Widget to display the progress of the module completion.
                _buildProgressWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Method to build the progress widget based on the percentage completion.
  Widget _buildProgressWidget() {
    if (cardData['percentageComplete'] == 100) {
      /// Display a checkmark if the module is completed.
      return Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEBEBEB),
        ),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmark,
        ),
      );
    } else if (cardData['percentageComplete'] < 50 && cardData['percentageComplete'] > 0)
    {
      /// Display progress bar if completion is less than 50%.
      return ProgressBar(
        percentageComplete: cardData['percentageComplete'],
        completedImages: cardData['completedImages'],
        totalImages: cardData['totalImages'],
        progressType: '0%',
      );
    } else if (cardData['percentageComplete'] >= 50) {
      /// Display progress bar if completion is at least 50%.
      return ProgressBar(
        percentageComplete: cardData['percentageComplete'],
        completedImages: cardData['completedImages'],
        totalImages: cardData['totalImages'],
        progressType: '50%',
      );
    } else {
      /// Display an arrow icon if no progress is made yet.
      return Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEBEBEB),
        ),
        child: Icon(Icons.arrow_forward),
      );
    }
  }
}
