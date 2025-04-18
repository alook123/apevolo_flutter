import 'package:apevolo_flutter/app/modules/components/captcha/controllers/captcha_controller.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/auth/authorization_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final UserService userService = Get.find<UserService>();
  final AuthorizationProvider authProvider = Get.find<AuthorizationProvider>();
  final CaptchaController captchaController = Get.find<CaptchaController>();

  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController captchaTextController = TextEditingController();

  final Rx<String?> loginFailedText = Rx(null);
  late final Encrypter? encrypter;

  @override
  Future<void> onInit() async {
    super.onInit();
    final publicPem =
        await rootBundle.loadString('assets/certificate/public_apevolo.pem');
    dynamic publicKey = RSAKeyParser().parse(publicPem);
    encrypter = Encrypter(RSA(publicKey: publicKey));
    if (kDebugMode) {
      usernameTextController.text = "apevolo";
      passwordTextController.text = "123456";
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await userService.loadUserInfo();
    if (userService.loginInfo.value != null) {
      Get.offAllNamed(Routes.SHELL);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    captchaController.onRefresh();
  }

  Future<void> onLogin() async {
    String passwordBase64 =
        encrypter!.encrypt(passwordTextController.text).base64;

    authProvider
        .login(
      usernameTextController.text,
      passwordBase64,
      captchaTextController.text,
      captchaController.captchaId,
    )
        .then(
      (value) async {
        loginFailedText.value = null;
        userService.loginInfo.value = value;
        Get.offAllNamed(Routes.SHELL);
      },
    ).catchError(
      (error) {
        loginFailedText.value =
            error is String ? error : error.response.data['message'].toString();
        Get.snackbar("错误", loginFailedText.value.toString());
        if (kDebugMode) {
          Get.defaultDialog(title: '错误', middleText: error.toString());
        }
      },
    );
  }
}
