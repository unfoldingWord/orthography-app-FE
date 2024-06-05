import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../controller/languageSelection_controller.dart';

class LanguageChipWidget extends StatelessWidget {
  final LanguageController controller = Get.put(LanguageController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      /// Obx widget listens to changes in langList and rebuilds the UI accordingly
          () => Wrap(
        runSpacing: 18.v,
        spacing: 18.h,
        children: List<Widget>.generate(
          controller.langList.length,
              (index) {
            final language = controller.langList[index];
            final isSelected = language.code == 'EN';

            return GestureDetector(
              onTap: () {
                /// Save the language code if it's not already selected
                if (!isSelected) {
                  controller.saveLangCode(language.code);
                }
              },
              child: Opacity(
                /// Set opacity based on selection
                opacity: isSelected ? 1.0 : 0.2,
                child: Container(
                  width: 140.v,
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                    border: Border.all(
                      color: isSelected ? appTheme.teal400 : Color(0xFF328190),
                      width: 1.h,
                    ),
                    color: isSelected ? appTheme.teal400 : Colors.transparent,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.h,
                    vertical: 8.v,
                  ),
                  child: Center(
                    child: Text(
                      language.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 16.fSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
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
}


