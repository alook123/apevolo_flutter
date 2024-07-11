import 'package:flutter/foundation.dart';
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
        onEmpty: const Text('验证码为空！'),
        onError: (error) {
          return const Text(
            '获取失败！',
            style: const TextStyle(color: Colors.red),
          );
        },
        onLoading: const CircularProgressIndicator(),
      ),
    );
  }
}
