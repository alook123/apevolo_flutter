/// 登录状态管理（Riverpod 2.0+ 新写法实现）
/// 负责管理登录页面的所有状态和业务逻辑
library login_provider;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'captcha_provider.dart';
import 'auth_provider.dart';

part 'login_provider.g.dart';

/// 登录页面的状态数据类
/// 包含登录页面所需的所有状态信息，采用不可变数据结构
class LoginState {
  /// 用户名输入框的内容
  final String username;

  /// 密码输入框的内容
  final String password;

  /// 是否正在进行登录操作，控制加载状态和按钮禁用
  final bool isLoading;

  /// 登录失败时的错误信息，为null表示无错误
  final String? error;

  /// 密码输入框是否显示明文，控制密码可见性
  final bool isPasswordVisible;

  /// 用户名历史记录列表，用于自动补全功能
  final List<String> usernameHistory;

  /// 当前用户名自动补全的建议文本
  final String currentSuggestion;

  /// 是否显示背景选择器（仅在调试模式下显示）
  final bool showBackgroundSelector;

  /// 背景类型的索引值，对应不同的背景主题
  final int backgroundTypeIndex;

  /// 验证码文本输入
  final String captchaText;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.isPasswordVisible = false,
    this.usernameHistory = const [],
    this.currentSuggestion = '',
    this.showBackgroundSelector = false,
    this.backgroundTypeIndex = 0,
    this.captchaText = '',
  });

  /// 生成一个新的 LoginState，允许部分字段变更
  LoginState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? error,
    bool? isPasswordVisible,
    List<String>? usernameHistory,
    String? currentSuggestion,
    bool? showBackgroundSelector,
    int? backgroundTypeIndex,
    String? captchaText,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      usernameHistory: usernameHistory ?? this.usernameHistory,
      currentSuggestion: currentSuggestion ?? this.currentSuggestion,
      showBackgroundSelector:
          showBackgroundSelector ?? this.showBackgroundSelector,
      backgroundTypeIndex: backgroundTypeIndex ?? this.backgroundTypeIndex,
      captchaText: captchaText ?? this.captchaText,
    );
  }
}

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    return const LoginState(
      showBackgroundSelector: kDebugMode,
    );
  }

  /// 更新用户名
  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  /// 更新密码
  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  /// 更新验证码文本
  void updateCaptchaText(String captchaText) {
    state = state.copyWith(captchaText: captchaText);
  }

  /// 切换密码可见性
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 接受自动补全建议
  /// 将当前的补全建议应用到用户名输入框，并清除建议状态
  void acceptSuggestion() {
    if (state.currentSuggestion.isNotEmpty) {
      state = state.copyWith(
        username: state.currentSuggestion,
        currentSuggestion: '',
      );
    }
  }

  /// 清除建议但不接受
  void clearSuggestionWithoutAccepting() {
    state = state.copyWith(currentSuggestion: '');
  }

  /// 设置背景类型
  void setBackgroundType(int index) {
    state = state.copyWith(backgroundTypeIndex: index);
  }

  /// 切换背景类型
  void toggleBackgroundType() {
    final newIndex = (state.backgroundTypeIndex + 1) % 2;
    state = state.copyWith(backgroundTypeIndex: newIndex);
  }

  /// 执行登录操作
  Future<void> login() async {
    if (state.username.isEmpty ||
        state.password.isEmpty ||
        state.captchaText.isEmpty) {
      state = state.copyWith(error: '请填写完整的登录信息');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 获取验证码provider来获取验证码ID
      final captchaAsyncValue = ref.read(captchaNotifierProvider);
      String? captchaId;

      captchaAsyncValue.when(
        data: (captchaState) => captchaId = captchaState.captchaId,
        loading: () => captchaId = null,
        error: (error, stack) => captchaId = null,
      );

      final authNotifier = ref.read(authNotifierProvider.notifier);

      final success = await authNotifier.login(
        state.username,
        state.password,
        state.captchaText,
        captchaId,
      );

      if (success) {
        state = state.copyWith(isLoading: false, error: null);
        // 登录成功，可以在这里触发导航或其他逻辑
      } else {
        // 获取auth错误信息
        final authState = ref.read(authNotifierProvider);
        state = state.copyWith(
          isLoading: false,
          error: authState.loginErrorText ?? '登录失败',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '登录过程中发生错误: $e',
      );
    }
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 重置表单
  void resetForm() {
    state = state.copyWith(
      username: '',
      password: '',
      captchaText: '',
      error: null,
      isLoading: false,
      currentSuggestion: '',
    );
  }
}
