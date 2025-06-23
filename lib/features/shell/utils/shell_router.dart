import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../user/views/user_management_view.dart';
import '../../setting/views/setting_view.dart';

/// Shell路由管理器
/// 负责根据菜单ID渲染对应的页面内容
class ShellRouter {
  /// 根据标签页ID获取对应的页面组件
  static Widget getPageByTabId(String tabId) {
    switch (tabId.toLowerCase()) {
      case 'user':
      case 'users':
      case '用户管理':
        return const UserManagementView();

      case 'dashboard':
      case 'home':
      case '仪表盘':
        return const DashboardView();

      case 'settings':
      case 'system':
      case '系统设置':
      case '设置':
        return const SettingView();

      case 'permission':
      case 'role':
      case '权限管理':
        return const PermissionManagementView();

      case 'menu':
      case '菜单管理':
        return const MenuManagementView();

      default:
        return UnknownPageView(tabId: tabId);
    }
  }

  /// 获取页面标题
  static String getPageTitle(String tabId) {
    switch (tabId.toLowerCase()) {
      case 'user':
      case 'users':
        return '用户管理';
      case 'dashboard':
      case 'home':
        return '仪表盘';
      case 'settings':
      case 'system':
      case '设置':
        return '设置';
      case 'permission':
      case 'role':
        return '权限管理';
      case 'menu':
        return '菜单管理';
      default:
        return tabId;
    }
  }

  /// 获取页面图标
  static IconData getPageIcon(String tabId) {
    switch (tabId.toLowerCase()) {
      case 'user':
      case 'users':
        return Icons.people;
      case 'dashboard':
      case 'home':
        return Icons.dashboard;
      case 'settings':
      case 'system':
        return Icons.settings;
      case 'permission':
      case 'role':
        return Icons.security;
      case 'menu':
        return Icons.menu;
      default:
        return Icons.web;
    }
  }
}

/// 仪表盘页面
class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '仪表盘',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // 统计卡片
            Row(
              children: [
                Expanded(
                    child: _buildStatCard(
                        context, '用户总数', '1,234', Icons.people, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildStatCard(context, '在线用户', '87',
                        Icons.online_prediction, Colors.green)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildStatCard(context, '今日访问', '2,456',
                        Icons.visibility, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildStatCard(
                        context, '系统负载', '76%', Icons.memory, Colors.red)),
              ],
            ),
            const SizedBox(height: 24),

            // 图表区域
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('访问趋势',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '图表占位符\n(集成图表库如 fl_chart)',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('最近活动',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildActivityItem('用户 张三 登录系统', '2分钟前'),
                                  _buildActivityItem('用户 李四 修改密码', '5分钟前'),
                                  _buildActivityItem('管理员 更新了系统配置', '10分钟前'),
                                  _buildActivityItem('新用户 王五 注册', '15分钟前'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        )),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(activity)),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

/// 系统设置页面
class SystemSettingsView extends ConsumerWidget {
  const SystemSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '系统设置',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('系统设置页面开发中...'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 权限管理页面
class PermissionManagementView extends ConsumerWidget {
  const PermissionManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '权限管理',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('权限管理页面开发中...'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 菜单管理页面
class MenuManagementView extends ConsumerWidget {
  const MenuManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '菜单管理',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('菜单管理页面开发中...'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 未知页面组件
class UnknownPageView extends ConsumerWidget {
  final String tabId;

  const UnknownPageView({super.key, required this.tabId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '页面未找到',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '标签页: $tabId',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: 返回首页或关闭标签页
              },
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}
