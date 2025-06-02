// 验证码状态管理（Riverpod实现）
// 负责请求验证码API、管理图片、ID、加载状态、错误等
import 'dart:convert';
import 'dart:typed_data';
import 'package:apevolo_flutter/app2/network/apevolo_com/models/auth/captcha_response.dart';
import 'package:apevolo_flutter/app2/network/apevolo_com/modules/auth_rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/app2/provider/api/auth_rest_client_provider.dart';

/// CaptchaState - 验证码的状态
/// 包含图片数据、验证码ID、加载中、错误、是否显示等
class CaptchaState {
  /// 验证码图片（内存数据，类型：Uint8List?）
  final Uint8List? image;

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
    this.image,
    this.captchaId,
    this.isLoading = false,
    this.error,
    this.isShowing = false,
  });

  /// 生成一个新的 CaptchaState，允许部分字段变更
  /// [image] 验证码图片
  /// [captchaId] 验证码ID
  /// [isLoading] 是否加载中
  /// [error] 错误信息
  /// [isShowing] 是否显示验证码
  CaptchaState copyWith({
    Uint8List? image,
    String? captchaId,
    bool? isLoading,
    String? error,
    bool? isShowing,
  }) {
    return CaptchaState(
      image: image ?? this.image,
      captchaId: captchaId ?? this.captchaId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isShowing: isShowing ?? this.isShowing,
    );
  }
}

/// CaptchaNotifier - 验证码状态管理器（AsyncValue结构）
/// 负责请求验证码API，管理验证码状态
class CaptchaNotifier extends StateNotifier<AsyncValue<CaptchaState>> {
  final AuthRestClient authRestClient;

  CaptchaNotifier(this.authRestClient) : super(const AsyncValue.loading()) {
    fetchCaptcha();
  }

  /// 拉取验证码图片和ID（异步，支持 AsyncValue 状态）
  Future<void> fetchCaptcha() async {
    state = const AsyncValue.loading();
    try {
      final CaptchaResponse result = await authRestClient.captcha();
      final Uint8List? image = result.img.isNotEmpty
          ? base64.decode(result.img.split(',').last)
          : null;
      state = AsyncValue.data(CaptchaState(
        image: image,
        captchaId: result.captchaId,
        isLoading: false,
        isShowing: result.showCaptcha ?? false,
        error: null,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 显式显示验证码区域（如登录失败时调用）
  void showCaptcha() {
    // 只有 state 为 data 且 isShowing 被 API 明确返回 false 时才允许隐藏，否则强制显示
    state = state.whenData((s) => s.copyWith(isShowing: true));
  }

  /// 显式隐藏验证码区域（如登录成功后调用）
  void hideCaptcha() {
    // 只有 API 明确返回 showCaptcha: false 时才允许隐藏，否则保持显示
    // 这里不主动设置 isShowing: false，交由 fetchCaptcha 的 API 结果决定
  }
}

/// captchaProvider - 验证码Provider（AsyncValue结构）
final captchaProvider =
    StateNotifierProvider<CaptchaNotifier, AsyncValue<CaptchaState>>((ref) {
  final authRestClient = ref.read(authRestClientProvider);
  return CaptchaNotifier(authRestClient);
});

/// 使用说明：
/// UI 层通过 ref.watch(captchaProvider) 获取 AsyncValue<CaptchaState>
/// 可用 .when/.maybeWhen/.whenData 等处理 loading、error、data 状态
