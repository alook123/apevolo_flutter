import 'package:get/get.dart';

import 'package:apevolo_flutter/app/modules/home/controllers/home_vertical_menu_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/menu_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeVerticalMenuController>(
      () => HomeVerticalMenuController(),
    );
    Get.lazyPut<MenuProvider>(
      () => MenuProvider(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
