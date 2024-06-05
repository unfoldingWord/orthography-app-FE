import 'package:flutter/cupertino.dart';
import 'package:orthoappflutter/core/app_export.dart';

class InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Explanation for increasing the counter
        Align(
          alignment: Alignment.center,
          child: Text(
            "Increase the counter below as",
            maxLines: 2,
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              color: Color(0xff324A5A),
            ),
          ),
        ),
        SizedBox(height: 3.v), // Vertical spacing
        /// Additional text for the counter
        Align(
          alignment: Alignment.center,
          child: Text(
            "per the number of syllables",
            maxLines: 2,
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              color: Color(0xff324A5A),
            ),
          ),
        ),
      ],
    );
  }
}
