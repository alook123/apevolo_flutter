import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/user/user_provider.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
    Get.lazyPut<UserProvider>(
        () => UserProvider(Get.find<ApevoloDioService>().dio));
  }
}
