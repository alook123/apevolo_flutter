import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/captcha_controller.dart';

class CaptchaView extends GetView<CaptchaController> {
  const CaptchaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.onRefresh();
      },
      child: controller.obx(
        (state) => Image.memory(state),
        onEmpty: const Text('验证码'),
        onError: (error) => Text(error.toString()),
        onLoading: const CircularProgressIndicator(),
      ),
    );
  }
}
