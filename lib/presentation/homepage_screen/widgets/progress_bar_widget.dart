import 'package:flutter/cupertino.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// Widget for displaying a progress bar.
class ProgressBar extends StatelessWidget {
  final dynamic percentageComplete;
  final dynamic completedImages;
  final dynamic totalImages;
  final dynamic progressType;

  /// Constructor to initialize the progress bar parameters.
  ProgressBar({
    required this.percentageComplete,
    required this.completedImages,
    required this.totalImages,
    required this.progressType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.h,
      height: 50.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 11.v,
              lineWidth: 3.v,
              percent: percentageComplete / 100,
              /// Set different progress colors based on the progress type.
              progressColor: progressType == '50%'
                  ? Color(0xffFFCC49)
                  : Color(0xffED1D1D),
              /// Set different background colors based on the progress type.
              backgroundColor: progressType == '50%'
                  ? Color(0xffFFCC49).withOpacity(0.3)
                  : Color(0xffF2B5AA),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              '${completedImages}/${totalImages}',
              style: TextStyle(
                /// Set text color based on the progress type.
                color: progressType == '50%' ? Color(0xffFFCC49) : Color(0xffED1D1D),
                fontSize: 10.fSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
