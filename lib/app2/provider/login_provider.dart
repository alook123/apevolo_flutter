import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_service_provider.dart';
import 'auth_provider.dart';
import '../service/user_service.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// 登录状态
class LoginState {
  final String username; // 用户名，输入框内容
  final String password; // 密码，输入框内容
  final bool isLoading; // 是否正在登录，控制按钮和加载动画
  final String? error; // 错误信息，登录失败时显示
  final bool isPasswordVisible; // 密码是否可见，控制密码框明文/密文
  final List<String> usernameHistory; // 历史用户名列表，用于自动补全
  final String currentSuggestion; // 当前用户名自动补全建议
  final bool showBackgroundSelector; // 是否显示背景选择器（调试模式下）
  final int backgroundTypeIndex; // 背景类型索引
  final bool rememberPassword; // 新增
  final String captchaText; // 新增：验证码输入内容

  LoginState({
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.isPasswordVisible = false,
    this.usernameHistory = const [],
    this.currentSuggestion = '',
    this.showBackgroundSelector = false,
    this.backgroundTypeIndex = 0,
    this.rememberPassword = false, // 新增
    this.captchaText = '', // 新增
  });

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
    bool? rememberPassword,
    String? captchaText, // 新增
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      usernameHistory: usernameHistory ?? this.usernameHistory,
      currentSuggestion: currentSuggestion ?? this.currentSuggestion,
      showBackgroundSelector:
          showBackgroundSelector ?? this.showBackgroundSelector,
      backgroundTypeIndex: backgroundTypeIndex ?? this.backgroundTypeIndex,
      rememberPassword: rememberPassword ?? this.rememberPassword,
      captchaText: captchaText ?? this.captchaText, // 新增
    );
  }
}

/// 登录业务逻辑 StateNotifier
class LoginNotifier extends StateNotifier<LoginState> {
  final UserService userService;
  final AuthNotifier authNotifier;
  bool _isHandlingAutocomplete = false;
  String _previousText = '';

  LoginNotifier(this.userService, this.authNotifier)
      : super(LoginState(showBackgroundSelector: kDebugMode)) {
    _loadUsernameHistory();
    if (kDebugMode) {
      state = state.copyWith(username: 'apevolo', password: '123456');
      _previousText = 'apevolo';
    }
    if (!kDebugMode) {
      _randomizeBackground();
    }
  }

  /// 设置用户名
  void setUsername(String username) {
    state = state.copyWith(username: username, error: null);
    _onUsernameChanged(username);
  }

  /// 设置密码
  void setPassword(String password) {
    state = state.copyWith(password: password, error: null);
  }

  /// 切换密码可见性
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 设置背景类型
  void setBackgroundType(int index) {
    state = state.copyWith(backgroundTypeIndex: index);
  }

  void _randomizeBackground() {
    final values = [0, 1]; // BackgroundType 枚举下标
    state = state.copyWith(
        backgroundTypeIndex: values[Random().nextInt(values.length)]);
  }

  void _loadUsernameHistory() {
    final history = userService.getUsernameHistory();
    state = state.copyWith(usernameHistory: history);
  }

  void _saveUsernameToHistory(String username) {
    if (username.isEmpty) return;
    final history = List<String>.from(state.usernameHistory);
    history.remove(username);
    history.insert(0, username);
    if (history.length > 10) {
      history.removeLast();
    }
    userService.saveUsernameHistory(history);
    state = state.copyWith(usernameHistory: history);
  }

  void _onUsernameChanged(String input) {
    if (_isHandlingAutocomplete) return;
    if (input.isEmpty) {
      state = state.copyWith(currentSuggestion: '');
      _previousText = input;
      return;
    }
    bool isDeleting = input.length < _previousText.length &&
        input == _previousText.substring(0, input.length);
    if (isDeleting) {
      state = state.copyWith(currentSuggestion: '');
      _previousText = input;
      return;
    }
    String suggestion = _findSuggestion(input);
    if (suggestion.isNotEmpty && suggestion != input) {
      state = state.copyWith(currentSuggestion: suggestion);
    } else {
      state = state.copyWith(currentSuggestion: '');
    }
    _previousText = input;
  }

  String _findSuggestion(String input) {
    if (input.isEmpty) return '';
    for (String username in state.usernameHistory) {
      if (username.toLowerCase().startsWith(input.toLowerCase()) &&
          username.length > input.length) {
        return username;
      }
    }
    return '';
  }

  void acceptSuggestion() {
    if (state.currentSuggestion.isNotEmpty) {
      state = state.copyWith(
          username: state.currentSuggestion, currentSuggestion: '');
      _previousText = state.currentSuggestion;
    }
  }

  void clearSuggestionWithoutAccepting() {
    if (state.currentSuggestion.isNotEmpty) {
      final actualInput = state.username;
      state = state.copyWith(username: actualInput, currentSuggestion: '');
      _previousText = actualInput;
    }
  }

  /// 设置记住密码
  void setRememberPassword(bool value) {
    state = state.copyWith(rememberPassword: value);
    userService.setRememberPassword(value, state.username, state.password);
  }

  void loadRememberedPassword() {
    final result = userService.getRememberedPassword(state.username);
    if (result != null) {
      state = state.copyWith(password: result);
    }
  }

  Future<void> fetchCaptcha() async {
    try {
      // 假设authNotifier有captcha方法
      // 这里只保留调用，不再维护 captchaImage/captchaId
      await authNotifier.authRestClient.captcha();
    } catch (e) {
      // 捕获异常但不再维护 captchaImage/captchaId
    }
  }

  void setCaptchaText(String value) {
    state = state.copyWith(captchaText: value);
  }

  /// 登录操作，调用 AuthProvider
  Future<void> login({String? captchaText, String? captchaId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await authNotifier.login(
        state.username,
        state.password,
        "",
        "",
      );
      if (success) {
        _saveUsernameToHistory(state.username);
        if (state.rememberPassword) {
          userService.setRememberPassword(true, state.username, state.password);
        }
        state = state.copyWith(isLoading: false, error: null);
        // 登录成功后可清空表单、跳转页面等
      } else {
        state = state.copyWith(
            isLoading: false, error: authNotifier.state.loginErrorText);
      }
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: '登录失败: \\${e.toString()}');
    }
  }
}

/// 登录 Provider
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final userService = ref.read(userServiceProvider);
  final authNotifier = ref.read(authProvider.notifier);
  return LoginNotifier(userService, authNotifier);
});
