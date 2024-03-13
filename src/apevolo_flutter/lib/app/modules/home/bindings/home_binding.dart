import 'package:apevolo_flutter/app/provider/apevolo_com/menu_provider.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuProvider>(
      () => MenuProvider(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
