/// 认证状态相关的数据模型
library auth_state;

/// 登录结果状态
class LoginResult {
  final bool success;
  final String? message;
  final dynamic data;

  const LoginResult({
    required this.success,
    this.message,
    this.data,
  });
}
