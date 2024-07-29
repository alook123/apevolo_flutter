import 'package:apevolo_flutter/app/modules/components/theme_mode/controllers/theme_mode_controller.dart';
import 'package:apevolo_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_menu_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_tag_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:get/get.dart';

import 'package:apevolo_flutter/app/modules/shell/controllers/shell_vertical_menu_controller.dart';

import '../controllers/shell_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorizationProvider>(
        () => AuthorizationProvider(Get.find<ApevoloDioService>().dio));
    Get.lazyPut<MenuProvider>(
        () => MenuProvider(Get.find<ApevoloDioService>().dio));
    Get.lazyPut<ShellVerticalMenuController>(
        () => ShellVerticalMenuController());
    Get.lazyPut<ThemeModeController>(() => ThemeModeController());
    Get.lazyPut<ShellMenuController>(() => ShellMenuController());
    Get.lazyPut<ShellTagController>(() => ShellTagController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ShellController>(() => ShellController());
  }
}
