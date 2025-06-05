/// 登录页面的状态管理器
///
/// 负责管理登录页面的所有状态和业务逻辑，包括：
/// - 用户名和密码的输入处理
/// - 用户名历史记录和自动补全
/// - 密码可见性控制
/// - 登录状态和错误信息
/// - 背景主题设置
/// - 验证码输入处理
///
/// 使用 Riverpod 的 StateNotifier 模式进行状态管理
library login_provider;

import 'package:apevolo_flutter/core/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_service_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// 登录页面的状态数据类
///
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

  /// 是否记住密码，用于自动填充功能
  final bool rememberPassword;

  /// 验证码输入框的内容
  final String captchaText;

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
    this.rememberPassword = false,
    this.captchaText = '',
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
    String? captchaText,
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
      captchaText: captchaText ?? this.captchaText,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  /// 用户服务，处理用户数据持久化
  final UserService userService;

  /// 认证状态管理器，处理登录认证逻辑
  final AuthNotifier authNotifier;

  /// 标记是否正在处理自动补全，防止递归调用
  bool _isHandlingAutocomplete = false;

  /// 记录上一次的输入文本，用于判断是否为删除操作
  String _previousText = '';

  /// 创建登录状态管理器实例
  ///
  /// [userService] 用户服务实例
  /// [authNotifier] 认证状态管理器实例
  LoginNotifier(this.userService, this.authNotifier)
      : super(LoginState(showBackgroundSelector: kDebugMode)) {
    _loadUsernameHistory();

    // 开发模式下预填充测试数据
    if (kDebugMode) {
      state = state.copyWith(username: 'apevolo', password: '123456');
      _previousText = 'apevolo';
    }

    // 生产模式下随机选择背景
    if (!kDebugMode) {
      _randomizeBackground();
    }
  }

  /// 设置用户名
  ///
  /// 更新状态中的用户名，清除错误信息，并触发自动补全逻辑
  ///
  /// [username] 新的用户名输入
  void setUsername(String username) {
    state = state.copyWith(username: username, error: null);
    _onUsernameChanged(username);
  }

  /// 设置密码
  ///
  /// 更新状态中的密码，清除错误信息
  ///
  /// [password] 新的密码输入
  void setPassword(String password) {
    state = state.copyWith(password: password, error: null);
  }

  /// 切换密码可见性
  ///
  /// 在明文和密文之间切换密码显示状态
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 设置背景类型
  ///
  /// 更新当前选择的背景主题索引
  ///
  /// [index] 背景类型索引
  void setBackgroundType(int index) {
    state = state.copyWith(backgroundTypeIndex: index);
  }

  /// 随机选择背景类型
  ///
  /// 在可用的背景类型中随机选择一个，用于生产环境的多样化体验
  void _randomizeBackground() {
    final values = [0, 1]; // BackgroundType 枚举下标
    state = state.copyWith(
        backgroundTypeIndex: values[Random().nextInt(values.length)]);
  }

  /// 从持久化存储中加载用户名历史记录
  ///
  /// 在初始化时调用，加载之前保存的用户名列表用于自动补全
  void _loadUsernameHistory() {
    final history = userService.getUsernameHistory();
    state = state.copyWith(usernameHistory: history);
  }

  /// 保存用户名到历史记录
  ///
  /// 将成功登录的用户名添加到历史记录顶部，限制最多保存10个
  ///
  /// [username] 要保存的用户名
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

  /// 处理用户名输入变化
  ///
  /// 根据输入变化提供自动补全建议，智能判断用户意图：
  /// - 如果是删除操作，清除建议
  /// - 如果是输入操作，查找匹配的历史记录
  ///
  /// [input] 当前用户名输入
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

  /// 在历史记录中查找匹配的用户名建议
  ///
  /// 从用户名历史记录中找到第一个以输入文本开头的用户名
  ///
  /// [input] 当前输入的文本
  ///
  /// 返回匹配的用户名，如果没有匹配则返回空字符串
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

  /// 接受自动补全建议
  ///
  /// 将当前的补全建议应用到用户名输入框，并清除建议状态
  void acceptSuggestion() {
    if (state.currentSuggestion.isNotEmpty) {
      state = state.copyWith(
          username: state.currentSuggestion, currentSuggestion: '');
      _previousText = state.currentSuggestion;
    }
  }

  /// 清除自动补全建议但不接受
  ///
  /// 在用户按Tab键或失去焦点时调用，保持当前输入不变但清除建议
  void clearSuggestionWithoutAccepting() {
    if (state.currentSuggestion.isNotEmpty) {
      final actualInput = state.username;
      state = state.copyWith(username: actualInput, currentSuggestion: '');
      _previousText = actualInput;
    }
  }

  /// 设置记住密码选项
  ///
  /// 更新记住密码状态，并根据设置保存或清除密码
  ///
  /// [value] 是否记住密码
  void setRememberPassword(bool value) {
    state = state.copyWith(rememberPassword: value);
    userService.setRememberPassword(value, state.username, state.password);
  }

  /// 加载已记住的密码
  ///
  /// 根据当前用户名尝试加载之前保存的密码
  void loadRememberedPassword() {
    final result = userService.getRememberedPassword(state.username);
    if (result != null) {
      state = state.copyWith(password: result);
    }
  }

  /// 获取验证码图片
  ///
  /// 调用认证服务获取新的验证码，用于登录验证
  ///
  /// 注意：实际的验证码图片和ID由 CaptchaProvider 管理
  Future<void> fetchCaptcha() async {
    try {
      // 调用认证服务获取验证码
      // await authNotifier.authRestClient.captcha();
    } catch (e) {
      // 静默处理异常，验证码相关错误由 CaptchaProvider 处理
    }
  }

  /// 设置验证码输入文本
  ///
  /// 更新用户输入的验证码内容
  ///
  /// [value] 验证码输入值
  void setCaptchaText(String value) {
    state = state.copyWith(captchaText: value);
  }

  /// 执行登录操作
  ///
  /// 处理用户登录流程，包括：
  /// - 设置加载状态
  /// - 调用认证服务进行登录验证
  /// - 处理登录成功后的逻辑（保存历史记录、记住密码等）
  /// - 处理登录失败的错误信息
  ///
  /// [captchaText] 验证码文本（可选）
  /// [captchaId] 验证码ID（可选）
  ///
  /// 返回 Future<void>，异步执行登录操作
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
      state = state.copyWith(isLoading: false, error: '登录失败: ${e.toString()}');
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final userService = ref.read(userServiceProvider);
  final authNotifier = ref.read(authNotifierProvider.notifier);
  return LoginNotifier(userService, authNotifier);
});
