/// 应用路由常量
/// 集中管理所有路由路径
class AppRoutes {
  /// 认证相关路由
  static const String login = '/login';
  static const String logout = '/logout';

  /// 主页面路由
  static const String shell = '/';
  static const String dashboard = '/dashboard';

  /// 用户管理路由
  static const String users = '/permission/users';
  static const String userProfile = '/user/profile';

  /// 系统设置路由
  static const String settings = '/settings';
  static const String systemConfig = '/system/config';

  /// 权限管理路由
  static const String permissions = '/permission';
  static const String roles = '/permission/roles';

  /// 菜单管理路由
  static const String menus = '/system/menus';

  /// 错误页面路由
  static const String notFound = '/404';
  static const String serverError = '/500';
}
