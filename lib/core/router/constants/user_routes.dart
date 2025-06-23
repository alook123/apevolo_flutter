/// 用户管理相关路由常量
/// 包含用户列表、个人资料、用户设置等功能的路由路径
class UserRoutes {
  /// 用户管理页面
  static const String management = '/permission/users';

  /// 用户个人资料页面
  static const String profile = '/user/profile';

  /// 用户设置页面（预留）
  static const String settings = '/user/settings';

  /// 用户头像设置页面（预留）
  static const String avatar = '/user/avatar';

  /// 用户详情页面
  /// 使用方法：UserRoutes.detail('123') => '/users/123'
  static String detail(String userId) => '/users/$userId';

  /// 用户编辑页面
  /// 使用方法：UserRoutes.edit('123') => '/users/123/edit'
  static String edit(String userId) => '/users/$userId/edit';

  /// 获取所有用户相关路由列表（不包含动态路由）
  static List<String> get all => [
        management,
        profile,
        settings,
        avatar,
      ];
}
