import 'package:apevolo_flutter/app/components/captcha/controllers/captcha_controller.dart';
import 'package:apevolo_flutter/app/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 使用AuthController处理认证逻辑
  final AuthController authController = Get.find<AuthController>();
  final CaptchaController _captchaController = Get.find<CaptchaController>();

  // UI控制器
  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController captchaTextController = TextEditingController();

  // 登录状态 - 使用自己的Rx变量
  final Rx<String?> loginFailedText = Rx<String?>(null);
  final RxBool isLoggingIn = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    // 监听AuthController中的状态变化
    ever(authController.loginErrorText, (value) {
      loginFailedText.value = value;
    });

    ever(authController.isLoggingIn, (value) {
      isLoggingIn.value = value;
    });

    // 在调试模式下预填充凭据
    if (kDebugMode) {
      usernameTextController.text = "apevolo";
      passwordTextController.text = "123456";
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // 检查是否已登录，如果已登录则导航到主界面
    await authController.validateLoginState();
  }

  @override
  void onClose() {
    // 释放文本控制器
    usernameTextController.dispose();
    passwordTextController.dispose();
    captchaTextController.dispose();
    super.onClose();
  }

  // 刷新验证码
  Future<void> onRefresh() async {
    _captchaController.onRefresh();
  }

  // 处理登录事件
  Future<void> onLogin() async {
    try {
      await authController.login(
        usernameTextController.text,
        passwordTextController.text,
        captchaTextController.text,
        _captchaController.captchaId,
      );
      // 登录成功的处理已经在AuthController中完成
    } catch (error) {
      // 错误处理已经在AuthController中完成
      if (kDebugMode) {
        print('登录控制器捕获到错误: $error');
      }
    }
  }
}
