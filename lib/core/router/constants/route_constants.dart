/// 路由常量统一导出文件
/// 方便其他文件导入所有路由常量
///
/// 使用示例：
/// ```dart
/// import 'package:apevolo_flutter/core/router/constants/route_constants.dart';
///
/// // 使用具体模块的路由
/// context.go(AuthRoutes.login);
/// context.go(UserRoutes.management);
/// context.go(SystemRoutes.settings);
///
/// // 或者使用动态路由
/// context.go(UserRoutes.detail('123'));
/// ```

// 导入所有路由常量类
import 'auth_routes.dart';
import 'user_routes.dart';
import 'system_routes.dart';
import 'permission_routes.dart';
import 'common_routes.dart';

// 导出所有路由常量类
export 'auth_routes.dart';
export 'user_routes.dart';
export 'system_routes.dart';
export 'permission_routes.dart';
export 'common_routes.dart';

/// 路由常量汇总类
/// 提供快速访问和工具方法
class RouteConstants {
  /// 获取所有静态路由路径
  static List<String> get allStaticRoutes => [
        ...AuthRoutes.all,
        ...UserRoutes.all,
        ...SystemRoutes.all,
        ...PermissionRoutes.all,
        ...CommonRoutes.all,
      ];

  /// 检查路径是否为有效的静态路由
  static bool isValidStaticRoute(String path) {
    return allStaticRoutes.contains(path);
  }

  /// 检查路径是否为错误页面路由
  static bool isErrorRoute(String path) {
    return CommonRoutes.errorPages.contains(path);
  }
}
