// 负责请求验证码API、管理图片、ID、加载状态、错误等
library captcha_provider;

import 'dart:convert';
import 'dart:typed_data';
import 'package:apevolo_flutter/shared/network/apevolo_com/models/auth/captcha_response.dart';
import 'package:apevolo_flutter/shared/providers/api/auth_rest_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'captcha_provider.g.dart';

/// CaptchaState - 验证码的状态
/// 包含图片数据、验证码ID、加载中、错误、是否显示等
class CaptchaState {
  /// 验证码图片（base64编码字符串，类型：String?）
  final String? imgText;

  /// 验证码图片（内存数据，类型：Uint8List?）
  Uint8List? get img =>
      imgText != null ? base64.decode(imgText!.split(',').last) : null;

  /// 验证码ID（类型：String?）
  final String? captchaId;

  /// 是否正在加载（类型：bool）
  final bool isLoading;

  /// 错误信息（类型：String?）
  final String? error;

  /// 是否显示验证码区域（类型：bool）
  /// 控制 UI 是否渲染验证码输入框和图片
  final bool isShowing;

  const CaptchaState({
    // this.image,
    this.imgText,
    this.captchaId,
    this.isLoading = false,
    this.error,
    this.isShowing = false,
  });

  /// 生成一个新的 CaptchaState，允许部分字段变更
  /// [imgText] 验证码图片文本（base64编码字符串）
  /// [captchaId] 验证码ID
  /// [isLoading] 是否加载中
  /// [error] 错误信息
  /// [isShowing] 是否显示验证码
  CaptchaState copyWith({
    // Uint8List? image,
    String? imgText,
    String? captchaId,
    bool? isLoading,
    String? error,
    bool? isShowing,
  }) {
    return CaptchaState(
      // image: image ?? this.image,
      imgText: imgText ?? this.imgText,
      captchaId: captchaId ?? this.captchaId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isShowing: isShowing ?? this.isShowing,
    );
  }
}

/// captchaProvider - 验证码Provider（新版 Riverpod 写法）
/// 使用 @riverpod 注解自动生成 Provider
/// 返回 AsyncValue<CaptchaState> 用于管理异步状态
@riverpod
class CaptchaNotifier extends _$CaptchaNotifier {
  @override
  Future<CaptchaState> build() async {
    // 初始化时自动获取验证码
    return await fetchCaptcha();
  }

  /// 拉取验证码图片和ID（公共方法）
  /// 既用于初始化，也用于刷新
  Future<CaptchaState> fetchCaptcha() async {
    final authRestClient = ref.read(authRestClientProvider);
    try {
      final CaptchaResponse result = await authRestClient.captcha();
      return CaptchaState(
        imgText: result.img,
        captchaId: result.captchaId,
        isLoading: false,
        isShowing: result.showCaptcha ?? false,
        error: null,
      );
    } catch (e) {
      rethrow; // AsyncValue 会自动处理错误状态
    }
  }

  /// 刷新验证码（触发重新获取）
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchCaptcha());
  }

  /// 显式显示验证码区域（如登录失败时调用）
  void showCaptcha() {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(isShowing: true));
    }
  }

  /// 显式隐藏验证码区域（如登录成功后调用）
  void hideCaptcha() {
    // 只有 API 明确返回 showCaptcha: false 时才允许隐藏，否则保持显示
    // 这里不主动设置 isShowing: false，交由 fetchCaptcha 的 API 结果决定
  }
}
