import 'package:apevolo_flutter/app/modules/widget/captcha/controllers/captcha_controller.dart';
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
  final AuthorizationProvider _provider2 = Get.find<AuthorizationProvider>();
  final CaptchaController captchaController = Get.find<CaptchaController>();

  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController captchaTextController = TextEditingController();

  final Rx<String?> loginFailedText = Rx(null);
  late final Encrypter? encrypter;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (kDebugMode) {
      usernameTextController.text = "apevolo";
      passwordTextController.text = "123456";
    }
    final publicPem =
        await rootBundle.loadString('assets/certificate/public_apevolo.pem');
    dynamic publicKey = RSAKeyParser().parse(publicPem);
    encrypter = Encrypter(RSA(publicKey: publicKey));
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
    captchaController.onRefresh();
  }

  Future<void> onLogin() async {
    String passwordBase64 =
        encrypter!.encrypt(passwordTextController.text).base64;

    _provider2
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
        Get.offAllNamed(Routes.HOME);
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
