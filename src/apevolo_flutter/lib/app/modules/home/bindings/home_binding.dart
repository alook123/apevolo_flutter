import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:get/get.dart';

import 'package:apevolo_flutter/app/modules/home/controllers/home_vertical_menu_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorizationProvider>(
        () => AuthorizationProvider(Get.find<ApevoloDioService>().dio));
    Get.lazyPut<MenuProvider>(
        () => MenuProvider(Get.find<ApevoloDioService>().dio));
    Get.lazyPut<HomeVerticalMenuController>(
      () => HomeVerticalMenuController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
