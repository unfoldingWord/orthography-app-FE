
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orthoappflutter/core/app_export.dart';

/// Widget for a disabled module item card.
class DisabledModuleItem extends StatelessWidget {
  final dynamic cardData;

  /// Constructor to initialize the card data.
  DisabledModuleItem({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2, /// Set the opacity to 0.2 for disabled appearance.
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
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
                              fontSize: 15.fSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /// Display an arrow icon for disabled modules.
                  Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEBEBEB), // Container color
                    ),
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
