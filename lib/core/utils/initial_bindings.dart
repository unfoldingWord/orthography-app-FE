import 'package:orthoappflutter/core/app_export.dart';
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Connectivity connectivity = Connectivity();
    Get.put(NetworkInfo(connectivity));
  }
}
