/// 通用路由常量
/// 包含主页面、错误页面、调试页面等通用功能的路由路径
class CommonRoutes {
  /// Shell 主页面（包含侧边栏和导航的容器页面）
  static const String shell = '/';

  /// 仪表盘页面
  static const String dashboard = '/dashboard';

  /// 404 页面未找到
  static const String notFound = '/404';

  /// 500 服务器错误页面
  static const String serverError = '/500';

  /// 403 无权限访问页面（预留）
  static const String forbidden = '/403';

  /// 调试菜单页面
  static const String debugMenu = '/debug/menu';

  /// 关于页面（预留）
  static const String about = '/about';

  /// 帮助页面（预留）
  static const String help = '/help';

  /// 获取所有通用路由列表
  static List<String> get all => [
        shell,
        dashboard,
        notFound,
        serverError,
        forbidden,
        debugMenu,
        about,
        help,
      ];

  /// 错误页面路由列表
  static List<String> get errorPages => [
        notFound,
        serverError,
        forbidden,
      ];
}
