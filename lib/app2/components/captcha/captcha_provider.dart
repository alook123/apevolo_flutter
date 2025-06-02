// 验证码状态管理（Riverpod实现）
// 负责请求验证码API、管理图片、ID、加载状态、错误等
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/modules/auth_rest_client.dart';
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

/// CaptchaNotifier - 验证码状态管理器
/// 负责请求验证码API，管理验证码状态
class CaptchaNotifier extends StateNotifier<CaptchaState> {
  /// AuthRestClient 实例（类型：AuthRestClient）
  final AuthRestClient authRestClient;

  /// 构造函数，初始化时自动拉取一次验证码
  CaptchaNotifier(this.authRestClient) : super(const CaptchaState()) {
    fetchCaptcha();
  }

  /// 拉取验证码图片和ID
  /// 异步方法，更新验证码图片、ID、显示状态、错误等
  Future<void> fetchCaptcha() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await authRestClient.captcha();
      final String imgBase64 = result["img"] ?? '';
      final String? captchaId = result["captchaId"];
      // 优先用后端 showCaptcha 字段，否则默认 true
      final bool isShowing = result.containsKey("showCaptcha")
          ? (result["showCaptcha"] ?? true)
          : true;
      Uint8List? image;
      if (imgBase64.isNotEmpty) {
        // 兼容data:image/png;base64,xxx格式
        final base64Str =
            imgBase64.contains(',') ? imgBase64.split(',')[1] : imgBase64;
        image = base64.decode(base64Str);
      }
      state = state.copyWith(
        image: image,
        captchaId: captchaId,
        isLoading: false,
        isShowing: isShowing,
        error: null,
      );
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: e.toString(), image: null);
    }
  }

  /// 显式显示验证码区域（如登录失败时调用）
  void showCaptcha() {
    state = state.copyWith(isShowing: true);
  }

  /// 显式隐藏验证码区域（如登录成功后调用）
  void hideCaptcha() {
    state = state.copyWith(isShowing: false);
  }
}

/// captchaProvider - 验证码Provider
/// 提供CaptchaNotifier实例，供UI层消费
final captchaProvider =
    StateNotifierProvider<CaptchaNotifier, CaptchaState>((ref) {
  final authRestClient = ref.read(authRestClientProvider);
  return CaptchaNotifier(authRestClient);
});

/// 使用说明：
/// UI 层通过 ref.watch(captchaProvider).isShowing 控制验证码区域显示
/// 需要强制显示/隐藏时可调用 notifier.showCaptcha()/hideCaptcha()
