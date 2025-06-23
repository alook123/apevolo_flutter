/// 路由配置（go_router 实现）
/// 提供路由常量、路由表和路由守卫功能
library app_router;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 导入页面
import 'package:apevolo_flutter/features/auth/views/login_view.dart';
import 'package:apevolo_flutter/features/shell/views/shell_view.dart';
import 'package:apevolo_flutter/features/setting/views/setting_view.dart';
import 'package:apevolo_flutter/features/auth/providers/auth_provider.dart';

/// 路由路径常量
class AppRoutes {
  static const String login = '/login';
  static const String shell = '/';
  static const String users = '/permission/users';
  static const String settings = '/settings';
  static const String notFound = '/404';
}

/// 路由配置 Provider
/// 提供全局路由配置，支持路由守卫和状态管理
final appRouterProvider = Provider<GoRouter>((ref) {
  // 监听认证状态变化
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,

    // 路由守卫：重定向逻辑
    redirect: (context, state) {
      final isLoggedIn = authState.token != null;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      // 如果未登录且不在登录页，跳转到登录页
      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      // 如果已登录且在登录页，跳转到主页
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.shell;
      }

      return null; // 不需要重定向
    },

    // 错误页面处理
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('页面未找到')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('错误: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('返回登录'),
            ),
          ],
        ),
      ),
    ),

    // 路由配置
    routes: [
      // 登录页面
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      // 主 Shell 页面（包含侧边栏等）
      GoRoute(
        path: AppRoutes.shell,
        name: 'shell',
        builder: (context, state) => const ShellView(),
        routes: [
          // 用户管理页面
          GoRoute(
            path: 'permission/users',
            name: 'users',
            builder: (context, state) => const UsersPage(),
          ),

          // 设置页面
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingView(),
          ),
        ],
      ),
    ],
  );
});

/// 临时占位页面（待迁移）
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '用户管理页面\n（待从 GetX 模块迁移）',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
