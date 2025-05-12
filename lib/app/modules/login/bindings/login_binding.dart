import 'package:apevolo_flutter/app/components/captcha/controllers/captcha_controller.dart';
import 'package:apevolo_flutter/app/components/material_background/controllers/material_background_controller.dart';
import 'package:apevolo_flutter/app/components/theme_mode/controllers/theme_mode_controller.dart';
import 'package:apevolo_flutter/app/components/apevolo_background/controllers/apevolo_background_controller.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/dio_service.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/modules/auth_rest_client.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ApevoloDioService>(() => ApevoloDioService());
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );

    Get.lazyPut<ApeVoloBackgroundController>(
      () => ApeVoloBackgroundController(),
    );

    Get.lazyPut<MaterialBackgroundController>(
      () => MaterialBackgroundController(),
    );

    Get.lazyPut<AuthRestClient>(
        () => AuthRestClient(Get.find<DioService>().dio));

    Get.lazyPut<CaptchaController>(() => CaptchaController());

    Get.lazyPut<ThemeModeController>(
      () => ThemeModeController(),
    );
  }
}
