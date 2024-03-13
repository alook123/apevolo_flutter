import 'package:apevolo_flutter/app/modules/widget/captcha/controllers/captcha_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/authorization_provider.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<AuthorizationProvider>(() => AuthorizationProvider());
    Get.lazyPut<CaptchaController>(() => CaptchaController());
  }
}
