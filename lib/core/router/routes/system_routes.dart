import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 系统管理相关路由配置
class SystemRoutes {
  static List<RouteBase> subRoutes = [
    // 系统配置页面
    GoRoute(
      path: 'system/config',
      name: 'systemConfig',
      builder: (context, state) => const SystemConfigPage(),
    ),

    // 菜单管理页面
    GoRoute(
      path: 'system/menus',
      name: 'menus',
      builder: (context, state) => const MenuManagementPage(),
    ),

    // 权限管理页面
    GoRoute(
      path: 'permission',
      name: 'permissions',
      builder: (context, state) => const PermissionManagementPage(),
    ),

    // 角色管理页面
    GoRoute(
      path: 'permission/roles',
      name: 'roles',
      builder: (context, state) => const RoleManagementPage(),
    ),
  ];
}

/// 临时占位页面（待迁移）
class SystemConfigPage extends StatelessWidget {
  const SystemConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '系统配置页面\n（待实现）',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MenuManagementPage extends StatelessWidget {
  const MenuManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '菜单管理页面\n（待实现）',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class PermissionManagementPage extends StatelessWidget {
  const PermissionManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '权限管理页面\n（待实现）',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RoleManagementPage extends StatelessWidget {
  const RoleManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '角色管理页面\n（待实现）',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
