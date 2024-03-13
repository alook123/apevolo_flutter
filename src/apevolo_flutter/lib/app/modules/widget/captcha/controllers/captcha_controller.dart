import 'dart:convert';
import 'dart:typed_data';

import 'package:apevolo_flutter/app/provider/apevolo_com/authorization_provider.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:get/get.dart';

class CaptchaController extends GetxController with StateMixin {
  final AuthorizationProvider _provider = Get.put(AuthorizationProvider());

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
    await _provider.captcha().then((value) {
      captchaId = value["captchaId"]!;
      String imgBase64 = value["img"]!;
      Uint8List captchaImage = base64.decode(imgBase64.split(',')[1]);
      change(captchaImage, status: RxStatus.success());
    }).onError((error, stackTrace) {
      Logger.write('error:$error');
      change(null, status: RxStatus.error(error.toString()));
    });
  }
}
