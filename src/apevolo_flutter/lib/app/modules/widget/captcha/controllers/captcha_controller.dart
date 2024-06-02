import 'dart:convert';

import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CaptchaController extends GetxController with StateMixin {
  final AuthorizationProvider _provider2 = Get.find<AuthorizationProvider>();

  late String captchaId;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    _provider2.captcha().then((value) {
      captchaId = value["captchaId"]!;
      String imgBase64 = value["img"]!;
      Uint8List captchaImage = base64.decode(imgBase64.split(',')[1]);
      change(captchaImage, status: RxStatus.success());
    }).onError((error, stackTrace) {
      Logger.write('error:$error');
      change(null, status: RxStatus.error(error.toString()));
      if (kDebugMode) {
        Get.defaultDialog(title: '错误', middleText: error.toString());
      }
    });
  }
}
