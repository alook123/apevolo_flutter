import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_user.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_login.freezed.dart';
part 'auth_login.g.dart';

/// 认证登录信息类
/// 包含用户成功登录后的认证用户信息和访问令牌
@freezed
abstract class AuthLogin with _$AuthLogin {
  const factory AuthLogin({
    /// 认证用户信息
    /// 包含用户的详细信息、角色和权限
    required AuthUser user,

    /// 访问令牌
    /// 包含API访问所需的令牌和过期信息
    required Token token,
  }) = _AuthLogin;

  /// 从JSON创建AuthLogin实例
  /// 用于将服务器返回的登录响应JSON数据转换为AuthLogin对象
  factory AuthLogin.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginFromJson(json);
}
