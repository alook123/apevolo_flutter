/// 系统管理相关路由常量
/// 包含系统设置、菜单管理、配置管理等功能的路由路径
class SystemRoutes {
  /// 系统设置页面
  static const String settings = '/settings';

  /// 系统配置页面
  static const String config = '/system/config';

  /// 菜单管理页面
  static const String menus = '/system/menus';

  /// 系统日志页面（预留）
  static const String logs = '/system/logs';

  /// 系统备份页面（预留）
  static const String backup = '/system/backup';

  /// 系统监控页面（预留）
  static const String monitor = '/system/monitor';

  /// 数据字典页面（预留）
  static const String dictionary = '/system/dictionary';

  /// 获取所有系统管理相关路由列表
  static List<String> get all => [
        settings,
        config,
        menus,
        logs,
        backup,
        monitor,
        dictionary,
      ];
}
