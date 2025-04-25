import 'package:get/get.dart';

import '../controllers/theme_mode_controller.dart';

class ThemeModeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeModeController>(
      () => ThemeModeController(),
    );
  }
}
