import 'package:apevolo_flutter/app/modules/components/search_filter/controllers/search_filter_controller.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    //var arg = Get.arguments;
    // var tag = Get.parameters['tag'];

    // var a = Get.routing;
    // var b = Get.rawRoute;

    Get.lazyPut<SearchFilterController>(() => SearchFilterController(),
        tag: Get.arguments);

    Get.lazyPut<UserController>(() => UserController(), tag: Get.arguments);
  }
}
