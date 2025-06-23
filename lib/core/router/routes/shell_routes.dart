import 'package:go_router/go_router.dart';
import 'package:apevolo_flutter/features/shell/views/shell_view.dart';
import 'package:apevolo_flutter/features/setting/views/setting_view.dart';
import '../app_routes.dart';
import 'user_routes.dart';
import 'system_routes.dart';

/// Shell 页面相关路由配置
class ShellRoutes {
  static List<RouteBase> routes = [
    // 主 Shell 页面（包含侧边栏等）
    GoRoute(
      path: AppRoutes.shell,
      name: 'shell',
      builder: (context, state) => const ShellView(),
      routes: [
        // 用户管理子路由
        ...UserRoutes.subRoutes,

        // 系统管理子路由
        ...SystemRoutes.subRoutes,

        // 设置页面
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingView(),
        ),
      ],
    ),
  ];
}
