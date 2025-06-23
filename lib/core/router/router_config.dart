import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/features/auth/providers/auth_provider.dart';
import 'app_routes.dart';
import 'routes/auth_routes.dart';
import 'routes/shell_routes.dart';

/// 构建错误页面
Widget _buildErrorPage(BuildContext context, GoRouterState state) {
  return Scaffold(
    appBar: AppBar(title: const Text('页面未找到')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('错误: ${state.error}'),
          const SizedBox(height: 8),
          Text('路径: ${state.matchedLocation}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('返回登录'),
          ),
        ],
      ),
    ),
  );
}

/// 路由配置 Provider（Riverpod 2.0+ 新写法）
/// 提供全局路由配置，支持路由守卫和状态管理
/// 自动监听认证状态变化并响应路由重定向
final appRouterProvider = Provider<GoRouter>((ref) {
  // 监听认证状态变化，当认证状态改变时自动重建路由
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,

    // 路由守卫：基于认证状态的重定向逻辑
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
    errorBuilder: (context, state) => _buildErrorPage(context, state),

    // 路由配置 - 组装所有模块的路由
    routes: [
      // 认证路由
      ...AuthRoutes.routes,

      // Shell 路由（包含所有子路由）
      ...ShellRoutes.routes,
    ],
  );
});
