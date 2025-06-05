/// 认证状态管理（Riverpod 2.0+ 新写法实现）
/// 负责管理用户认证状态和相关业务逻辑
library auth_provider;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:apevolo_flutter/shared/providers/user_service_provider.dart';
import 'package:apevolo_flutter/shared/providers/api/auth_rest_client_provider.dart';

part 'auth_provider.g.dart';

/// 认证状态数据类
/// 包含用户认证相关的所有状态信息，采用不可变数据结构
class AuthState {
  /// 是否正在登录
  final bool isLoggingIn;

  /// 是否正在登出
  final bool isLoggingOut;

  /// 登录错误信息
  final String? loginErrorText;

  /// 登录成功后的token（可用于判断是否已登录）
  final String? token;

  const AuthState({
    this.isLoggingIn = false,
    this.isLoggingOut = false,
    this.loginErrorText,
    this.token,
  });

  /// 生成一个新的AuthState，允许部分字段变更
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

/// 认证状态管理器
/// 负责认证相关的业务逻辑（登录、登出、加密、token管理等）
@riverpod
class AuthNotifier extends _$AuthNotifier {
  /// RSA加密器，用于加密密码
  Encrypter? _encrypter;

  @override
  AuthState build() {
    return const AuthState();
  }

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
    final userService = ref.read(userServiceProvider);
    final authRestClient = ref.read(authRestClientProvider);

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
    final userService = ref.read(userServiceProvider);
    final authRestClient = ref.read(authRestClientProvider);

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
  /// 如果本地有token，则返回true，否则返回false
  Future<bool> validateLoginState() async {
    final userService = ref.read(userServiceProvider);
    await userService.loadUserInfo();
    // 这里可以根据userService或state.token判断是否已登录
    return isLoggedIn();
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(loginErrorText: null);
  }
}
