import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/data/providers/apevolo_com/modules/auth_provider.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:apevolo_flutter/app/components/views/apevolo_background_view.dart';

/// 认证控制器
/// 负责处理所有认证相关操作：登录、注销等
class AuthController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  // 控制加载状态
  final RxBool isLoggingOut = false.obs;
  final RxBool isLoggingIn = false.obs;

  // 登录错误状态
  final Rx<String?> loginErrorText = Rx(null);

  // 用于加密的RSA加密器
  Encrypter? _encrypter;

  @override
  Future<void> onInit() async {
    super.onInit();
    // 初始化RSA加密器
    await _initEncrypter();
  }

  /// 初始化RSA加密器
  Future<void> _initEncrypter() async {
    try {
      final publicPem =
          await rootBundle.loadString('assets/certificate/public_apevolo.pem');
      dynamic publicKey = RSAKeyParser().parse(publicPem);
      _encrypter = Encrypter(RSA(publicKey: publicKey));
    } catch (e) {
      if (kDebugMode) {
        print('初始化RSA加密器失败: $e');
      }
    }
  }

  /// 执行登录操作
  ///
  /// [username] 用户名
  /// [password] 密码（明文，将会被加密）
  /// [captchaText] 验证码
  /// [captchaId] 验证码ID
  /// 返回登录结果，成功时返回AuthLogin对象，失败时抛出异常
  Future<AuthLogin> login(
    String username,
    String password,
    String captchaText,
    String? captchaId,
  ) async {
    try {
      isLoggingIn.value = true;
      loginErrorText.value = null;

      // 确保加密器已初始化
      if (_encrypter == null) {
        await _initEncrypter();
        if (_encrypter == null) {
          throw Exception('RSA加密器初始化失败');
        }
      }

      // 加密密码
      String passwordBase64 = _encrypter!.encrypt(password).base64;

      // 调用登录API
      final loginResult = await _authProvider.login(
        username,
        passwordBase64,
        captchaText,
        captchaId,
      );

      // 保存登录信息
      _userService.loginInfo.value = loginResult;

      // 清理背景资源
      ApeVoloBackground.clearResources();

      // 导航到主界面
      await Get.offAllNamed(Routes.SHELL);

      return loginResult;
    } catch (e) {
      // 设置错误信息
      if (e is Exception) {
        final error = e;
        loginErrorText.value = error is String
            ? error.toString() // 明确转换为String
            : error.toString().contains('response')
                ? error
                    .toString()
                    .split('message')[1]
                    .replaceAll(RegExp(r'[^\u4e00-\u9fa5]'), '')
                : error.toString();
      } else {
        loginErrorText.value = e.toString();
      }

      // 显示错误提示
      Get.snackbar("登录失败", loginErrorText.value.toString());

      if (kDebugMode) {
        print('登录失败: $e');
      }

      // 重新抛出异常，让调用者处理
      rethrow;
    } finally {
      isLoggingIn.value = false;
    }
  }

  /// 执行注销操作
  ///
  /// 返回一个Future，表示注销操作的结果
  /// 成功时返回true，失败时抛出异常
  Future<bool> logout() async {
    try {
      isLoggingOut.value = true;

      // 如果有token，向服务器发送注销请求
      if (_userService.loginInfo.value?.token != null) {
        try {
          // 调用后端API注销，可能需要根据具体API调整
          await _authProvider.logout();
        } catch (e) {
          // 即使服务器注销失败，仍然继续清除本地数据
          if (kDebugMode) {
            print('服务器注销失败，但将继续清除本地数据: $e');
          }
        }
      }

      // 清除本地用户数据
      await _userService.clearUserInfo();

      // 重定向到登录页面
      Get.offAllNamed(Routes.LOGIN);

      if (kDebugMode) {
        print('用户已成功注销');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('注销过程中发生错误: $e');
      }

      // 重新抛出异常，让调用者处理
      rethrow;
    } finally {
      isLoggingOut.value = false;
    }
  }

  /// 检查用户是否已登录
  bool isLoggedIn() {
    return _userService.loginInfo.value != null;
  }

  /// 验证当前登录状态，如果已登录则导航到主界面
  Future<void> validateLoginState() async {
    await _userService.loadUserInfo();
    if (isLoggedIn()) {
      Get.offAllNamed(Routes.SHELL);
    }
  }
}
