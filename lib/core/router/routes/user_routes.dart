import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 用户管理相关路由配置
class UserRoutes {
  static List<RouteBase> subRoutes = [
    // 用户管理页面
    GoRoute(
      path: 'permission/users',
      name: 'users',
      builder: (context, state) => const UsersPage(),
    ),

    // 用户个人资料页面
    GoRoute(
      path: 'user/profile',
      name: 'userProfile',
      builder: (context, state) => const UserProfilePage(),
    ),
  ];
}

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

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '用户个人资料页面\n（待实现）',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
