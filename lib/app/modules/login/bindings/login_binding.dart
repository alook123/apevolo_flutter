import 'package:apevolo_flutter/app/modules/components/captcha/controllers/captcha_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ApevoloDioService>(() => ApevoloDioService());
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );

    Get.lazyPut<AuthorizationProvider>(
        () => AuthorizationProvider(Get.find<ApevoloDioService>().dio));

    Get.lazyPut<CaptchaController>(() => CaptchaController());
  }
}
