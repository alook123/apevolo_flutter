import 'dart:convert';

import 'package:apevolo_flutter/app/data/providers/apevolo_com/modules/auth_provider.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CaptchaController extends GetxController with StateMixin {
  final AuthProvider _provider = Get.find<AuthProvider>();

  late String captchaId;

  // late bool? showCaptcha = true;

  final Rx<bool> isShowing = false.obs;

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
    _provider.captcha().then((value) {
      captchaId = value["captchaId"]!;
      String imgBase64 = value["img"]!;
      Uint8List captchaImage = base64.decode(imgBase64.split(',')[1]);
      isShowing.value = value["showCaptcha"] ?? false;
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
