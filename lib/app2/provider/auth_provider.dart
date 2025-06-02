import 'package:apevolo_flutter/app2/network/apevolo_com/modules/auth_rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/user_service.dart';
import 'user_service_provider.dart';
import 'api/auth_rest_client_provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// AuthState
///
/// 认证相关的全局状态，包括登录/登出状态、错误信息、token等
class AuthState {
  /// 是否正在登录
  final bool isLoggingIn;

  /// 是否正在登出
  final bool isLoggingOut;

  /// 登录错误信息
  final String? loginErrorText;

  /// 登录成功后的token（可用于判断是否已登录）
  final String? token;

  AuthState({
    this.isLoggingIn = false,
    this.isLoggingOut = false,
    this.loginErrorText,
    this.token,
  });

  AuthState copyWith({
    bool? isLoggingIn,
    bool? isLoggingOut,
    String? loginErrorText,
    String? token,
  }) {
    return AuthState(
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      loginErrorText: loginErrorText,
      token: token ?? this.token,
    );
  }
}

/// AuthNotifier
///
/// 负责认证相关的业务逻辑（登录、登出、加密、token管理等）
/// 依赖 UserService（和未来的 AuthRestClient）
class AuthNotifier extends StateNotifier<AuthState> {
  final UserService userService;
  final AuthRestClient authRestClient;
  Encrypter? _encrypter; // 用于RSA加密密码

  AuthNotifier(this.userService, this.authRestClient) : super(AuthState());

  /// 初始化RSA加密器（用于加密密码）
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

  /// 登录操作
  ///
  /// [username] 用户名
  /// [password] 明文密码（会加密）
  /// [captchaText] 验证码
  /// [captchaId] 验证码ID
  /// 成功返回true，失败返回false并设置错误信息
  Future<bool> login(
    String username,
    String password,
    String captchaText,
    String? captchaId,
  ) async {
    state = state.copyWith(isLoggingIn: true, loginErrorText: null);
    try {
      if (_encrypter == null) {
        await _initEncrypter();
        if (_encrypter == null) throw Exception('RSA加密器初始化失败');
      }
      String passwordBase64 = _encrypter!.encrypt(password).base64;
      final loginResult = await authRestClient.login(
        username,
        passwordBase64,
        captchaText,
        captchaId,
      );
      await userService.saveUserInfo(loginResult);
      state = state.copyWith(
          token: loginResult.token.accessToken, isLoggingIn: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoggingIn: false, loginErrorText: e.toString());
      return false;
    }
  }

  /// 注销/登出操作
  /// 清除本地用户信息，重置token，并调用后端API
  Future<void> logout() async {
    state = state.copyWith(isLoggingOut: true);
    try {
      await authRestClient.logout();
      await userService.clearUserInfo();
      state = state.copyWith(isLoggingOut: false, token: null);
    } catch (e) {
      state = state.copyWith(isLoggingOut: false);
    }
  }

  /// 判断当前是否已登录
  bool isLoggedIn() {
    return state.token != null;
  }

  /// 校验本地登录状态（可用于启动时自动跳转）
  ///
  /// 如果本地有 token，则返回 true，否则返回 false
  Future<bool> validateLoginState() async {
    await userService.loadUserInfo();
    // 这里可以根据 userService 或 state.token 判断是否已登录
    return isLoggedIn();
  }
}

/// AuthProvider
///
/// Riverpod Provider，暴露 AuthNotifier 实例
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userService = ref.read(userServiceProvider);
  final authRestClient = ref.read(authRestClientProvider);
  return AuthNotifier(userService, authRestClient);
});
