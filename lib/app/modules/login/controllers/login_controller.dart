import 'package:apevolo_flutter/app/components/captcha/controllers/captcha_controller.dart';
import 'package:apevolo_flutter/app/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';

// 背景类型枚举
enum BackgroundType {
  apevolo,
  material,
  // 以后可以在这里添加更多背景类型
}

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 使用AuthController处理认证逻辑
  final AuthController authController = Get.find<AuthController>();
  final CaptchaController captchaController = Get.find<CaptchaController>();

  // UI控制器
  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController captchaTextController = TextEditingController();

  // 密码可见性控制
  final RxBool isPasswordVisible = false.obs;

  // 背景控制 - 使用枚举类型
  final Rx<BackgroundType> backgroundType = BackgroundType.apevolo.obs;

  // 显示背景选择器 (仅在调试模式下)
  final RxBool showBackgroundSelector = kDebugMode.obs;

  // 用户名输入框的焦点节点
  late final FocusNode usernameFocusNode = FocusNode();

  // 登录状态 - 使用自己的Rx变量
  final Rx<String?> loginFailedText = Rx<String?>(null);
  final RxBool isLoggingIn = false.obs;

  // 用户名历史记录
  final RxList<String> usernameHistory = <String>[].obs;
  final RxString currentSuggestion = ''.obs;

  // 是否正在处理自动完成，避免循环调用
  bool _isHandlingAutocomplete = false;

  // 用于跟踪上一次的文本，判断是否是删除操作
  String _previousText = '';

  final _storage = GetStorage();
  static const String _usernameHistoryKey = 'username_history';

  @override
  Future<void> onInit() async {
    super.onInit();

    // 随机选择背景类型 (在非调试模式下)
    if (!kDebugMode) {
      _randomizeBackground();
    }

    // 监听AuthController中的状态变化
    ever(authController.loginErrorText, (value) {
      loginFailedText.value = value;
    });

    ever(authController.isLoggingIn, (value) {
      isLoggingIn.value = value;
    });

    // 加载历史用户名
    _loadUsernameHistory();

    // 监听用户名输入变化
    usernameTextController.addListener(_onUsernameChanged);

    // 在调试模式下预填充凭据
    if (kDebugMode && usernameTextController.text.isEmpty) {
      usernameTextController.text = "apevolo";
      passwordTextController.text = "123456";
      _previousText = usernameTextController.text;
    }
  }

  // 随机选择背景
  void _randomizeBackground() {
    // 随机选择一个背景类型
    const values = BackgroundType.values;
    backgroundType.value = values[Random().nextInt(values.length)];
  }

  // 设置背景类型
  void setBackgroundType(BackgroundType type) {
    backgroundType.value = type;
  }

  // 加载用户名历史记录
  void _loadUsernameHistory() {
    final history = _storage.read<List<dynamic>>(_usernameHistoryKey);
    if (history != null) {
      usernameHistory.value = history.map((e) => e.toString()).toList();
    }
  }

  // 保存用户名到历史记录
  void _saveUsernameToHistory(String username) {
    if (username.isEmpty) return;

    // 移除已存在的相同用户名（如果有）
    usernameHistory.remove(username);

    // 将新用户名添加到列表开头
    usernameHistory.insert(0, username);

    // 限制历史记录数量（最多保存10个）
    if (usernameHistory.length > 10) {
      usernameHistory.removeLast();
    }

    // 保存到storage
    _storage.write(_usernameHistoryKey, usernameHistory.toList());
  }

  // 当用户名输入框内容变化时触发
  void _onUsernameChanged() {
    // 避免递归调用（当我们在此方法中更新文本时，会再次触发此监听器）
    if (_isHandlingAutocomplete) return;

    String input = usernameTextController.text;

    if (input.isEmpty) {
      currentSuggestion.value = '';
      _previousText = input;
      return;
    }

    // 检查是否是删除操作 - 通过比较当前文本与上一次的文本
    bool isDeleting = input.length < _previousText.length &&
        input == _previousText.substring(0, input.length);

    if (isDeleting) {
      // 删除操作，不显示建议
      currentSuggestion.value = '';
      _previousText = input;
      return;
    }

    // 如果正在输入（没有选中文本），查找匹配的建议
    if (!_hasSelection()) {
      String suggestion = _findSuggestion(input);

      if (suggestion.isNotEmpty && suggestion != input) {
        _isHandlingAutocomplete = true;

        // 保存当前光标位置
        int cursorPosition = usernameTextController.selection.baseOffset;

        // 设置建议文本
        usernameTextController.text = suggestion;

        // 选中建议的后半部分
        usernameTextController.selection = TextSelection(
            baseOffset: cursorPosition, extentOffset: suggestion.length);

        // 更新当前建议
        currentSuggestion.value = suggestion;

        _isHandlingAutocomplete = false;
      } else {
        currentSuggestion.value = '';
      }
    }

    // 更新上一次的文本
    _previousText = input;
  }

  // 检查是否有文本被选中
  bool _hasSelection() {
    return usernameTextController.selection.baseOffset !=
        usernameTextController.selection.extentOffset;
  }

  // 在历史记录中查找匹配的建议
  String _findSuggestion(String input) {
    if (input.isEmpty) return '';

    // 在历史记录中查找以输入文本开头的用户名
    for (String username in usernameHistory) {
      if (username.toLowerCase().startsWith(input.toLowerCase()) &&
          username.length > input.length) {
        return username;
      }
    }

    // 移除特殊情况处理，让用户能输入准确的用户名
    return '';
  }

  // 接受当前建议
  void acceptSuggestion() {
    if (currentSuggestion.value.isNotEmpty) {
      usernameTextController.text = currentSuggestion.value;
      usernameTextController.selection =
          TextSelection.collapsed(offset: currentSuggestion.value.length);
      currentSuggestion.value = '';
      _previousText = usernameTextController.text;
    }
  }

  // 清除当前建议而不接受它
  void clearSuggestionWithoutAccepting() {
    // 保存当前实际输入的文本（不包括建议的部分）
    if (currentSuggestion.value.isNotEmpty) {
      String actualInput = usernameTextController.text
          .substring(0, usernameTextController.selection.baseOffset);

      // 只保留用户实际输入的部分
      _isHandlingAutocomplete = true;
      usernameTextController.text = actualInput;
      usernameTextController.selection =
          TextSelection.collapsed(offset: actualInput.length);
      _isHandlingAutocomplete = false;

      currentSuggestion.value = '';
      _previousText = usernameTextController.text;
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
    // 移除监听器
    usernameTextController.removeListener(_onUsernameChanged);

    // 释放焦点节点
    usernameFocusNode.dispose();

    // 释放文本控制器
    usernameTextController.dispose();
    passwordTextController.dispose();
    captchaTextController.dispose();
    super.onClose();
  }

  // 刷新验证码
  Future<void> onRefresh() async {
    captchaController.onRefresh();
  }

  // 处理登录事件
  Future<void> onLogin() async {
    try {
      await authController.login(
        usernameTextController.text,
        passwordTextController.text,
        captchaTextController.text,
        captchaController.captchaId,
      );

      // 保存用户名到历史记录
      _saveUsernameToHistory(usernameTextController.text);

      // 登录成功的处理已经在AuthController中完成
    } catch (error) {
      // 错误处理已经在AuthController中完成
      if (kDebugMode) {
        print('登录控制器捕获到错误: $error');
      }
    }
  }

  // 切换密码可见性
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
