import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';
part 'token.g.dart';

/// 令牌类
/// 用于存储和管理API的访问令牌及相关信息
@freezed
abstract class Token with _$Token {
  const factory Token({
    /// 访问令牌
    /// 用于API认证的主要令牌
    @JsonKey(name: 'access_token') String? accessToken,

    /// 访问令牌过期时间（秒）
    /// 指示访问令牌的有效期
    @JsonKey(name: 'expires_in') required int expiresIn,

    /// 令牌类型
    /// 通常为"Bearer"，指示令牌的使用方式
    @JsonKey(name: 'token_type') required String tokenType,

    /// 刷新令牌
    /// 用于在访问令牌过期后获取新的访问令牌
    @JsonKey(name: 'refresh_token') required String refreshToken,

    /// 刷新令牌过期时间（秒）
    /// 指示刷新令牌的有效期
    @JsonKey(name: 'refresh_token_expires_in')
    required int refreshTokenExpiresIn,
  }) = _Token;

  /// 从JSON创建Token实例
  /// 用于将服务器返回的JSON数据转换为Token对象
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
