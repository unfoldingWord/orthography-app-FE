
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/presentation/homepage_screen/widgets/header_information_widget.dart';
import 'package:orthoappflutter/presentation/homepage_screen/widgets/homepage_module_cards_list.dart';
import 'package:orthoappflutter/presentation/sidebar_component_screen/sidebar_component_screen.dart';
import '../controller/homepage_controller.dart';

class HomepageScreen extends StatelessWidget {
  /// Key for the scaffold widget
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Homepage controller instance
  final HomepageController controller = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// Handles back button press
      onWillPop: () async {
        /// Navigates back
        Get.back();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          /// Drawer Widget
          drawer: Drawer(
            child: SidebarComponentScreen(),
          ),
          body: SizedBox(
            width: double.maxFinite,
            child: Stack(
              children: [
                /// Home Page Header Information Widget
                HomePageHeaderInfo(HomePageClassKey: scaffoldKey),
                ///Home Page Modules List Widget
                ModuleCardsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
