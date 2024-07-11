import 'package:apevolo_flutter/app/modules/components/search_filter/controllers/search_filter_controller.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFilterController>(
      () => SearchFilterController(),
    );

    Get.lazyPut<UserController>(
      () => UserController(),
    );
  }
}
