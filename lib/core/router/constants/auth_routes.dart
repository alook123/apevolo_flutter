/// 认证相关路由常量
/// 包含登录、登出、注册等认证功能的路由路径
class AuthRoutes {
  /// 登录页面
  static const String login = '/login';

  /// 登出路由
  static const String logout = '/logout';

  /// 注册页面（预留）
  static const String register = '/register';

  /// 忘记密码页面（预留）
  static const String forgotPassword = '/forgot-password';

  /// 重置密码页面（预留）
  static const String resetPassword = '/reset-password';

  /// 获取所有认证相关路由列表
  static List<String> get all => [
        login,
        logout,
        register,
        forgotPassword,
        resetPassword,
      ];
}
