import 'package:apevolo_flutter/app/modules/components/search_filter/controllers/search_filter_controller.dart';
import 'package:apevolo_flutter/app/modules/permission/user/controllers/user_search_controller.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFilterController>(() => SearchFilterController(),
        tag: Get.arguments);
    Get.lazyPut<UserSearchController>(() => UserSearchController(),
        tag: Get.arguments);
    Get.lazyPut<UserController>(() => UserController(), tag: Get.arguments);
  }
}
