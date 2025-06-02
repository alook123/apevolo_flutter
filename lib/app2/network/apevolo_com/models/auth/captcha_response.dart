import 'package:freezed_annotation/freezed_annotation.dart';

part 'captcha_response.freezed.dart';
part 'captcha_response.g.dart';

/// 验证码接口响应实体
@freezed
abstract class CaptchaResponse with _$CaptchaResponse {
  const factory CaptchaResponse({
    /// base64图片字符串
    required String img,

    /// 验证码ID
    required String captchaId,

    /// 是否显示验证码（可选）
    bool? showCaptcha,
  }) = _CaptchaResponse;

  factory CaptchaResponse.fromJson(Map<String, dynamic> json) =>
      _$CaptchaResponseFromJson(json);
}
