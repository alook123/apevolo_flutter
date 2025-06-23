import 'package:go_router/go_router.dart';
import 'package:apevolo_flutter/features/auth/views/login_view.dart';
import '../app_routes.dart';

/// 认证相关路由配置
class AuthRoutes {
  static List<RouteBase> routes = [
    // 登录页面
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
  ];
}
