import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/features/auth/providers/auth_provider.dart';
import 'package:apevolo_flutter/shared/widgets/error_page_view.dart';
import 'constants/route_constants.dart';
import 'routes/auth_routes.dart' as route_config;
import 'routes/shell_routes.dart' as route_config;

/// 路由配置 Provider
/// 提供全局路由配置，支持路由守卫和状态管理
/// 自动监听认证状态变化并响应路由重定向
final appRouterProvider = Provider<GoRouter>((ref) {
  // 监听认证状态变化，当认证状态改变时自动重建路由
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AuthRoutes.login,
    debugLogDiagnostics: true,

    // 路由守卫：基于认证状态的重定向逻辑
    redirect: (context, state) {
      final isLoggedIn = authState.token != null;
      final isLoggingIn = state.matchedLocation == AuthRoutes.login;

      // 如果未登录且不在登录页，跳转到登录页
      if (!isLoggedIn && !isLoggingIn) {
        return AuthRoutes.login;
      }

      // 如果已登录且在登录页，跳转到主页
      if (isLoggedIn && isLoggingIn) {
        return CommonRoutes.shell;
      }

      return null; // 不需要重定向
    },

    // 错误页面处理
    errorBuilder: (context, state) => ErrorPageView.router(routerState: state),

    // 路由配置 - 组装所有模块的路由
    routes: [
      // 认证路由
      ...route_config.AuthRoutes.routes,

      // Shell 路由（包含所有子路由）
      ...route_config.ShellRoutes.routes,
    ],
  );
});
