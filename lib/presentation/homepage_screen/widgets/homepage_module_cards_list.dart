
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/homepage_screen/widgets/disabled_module_card_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controller/homepage_controller.dart';
import 'module_card_item_widget.dart';

class ModuleCardsList extends StatelessWidget {
  /// Instantiate the HomepageController
  final HomepageController controller = HomepageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 220.h),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.HomePageCompList.length,
        itemBuilder: (context, index) {
          /// Used GetBuilder to rebuild the widget when the controller state changes
          return GetBuilder<HomepageController>(
            builder: (controller) {
              /// Used Skeletonizer to show a loading skeleton when data is loading
              return Skeletonizer(
                enabled: controller.isLoading.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.v, right: 16.v, bottom: 8.h),
                    child: controller.HomePageCompList[index]['isOpen'] == true
                        ? ModuleItemCard(cardData: controller.HomePageCompList[index])
                        : DisabledModuleItem(cardData: controller.HomePageCompList[index]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
