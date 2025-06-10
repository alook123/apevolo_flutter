import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shell_state.dart';
import '../providers/shell_provider.dart';
import 'shell_tab_bar.dart';
import '../utils/shell_router.dart';

/// Shell 内容区域 - 包含标签页和内容显示
class ShellContentArea extends ConsumerWidget {
  const ShellContentArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsyncValue = ref.watch(shellMenuProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: [
          // 顶部标签栏
          _buildTopTabBar(context, ref, menuAsyncValue),

          // 内容区域
          Expanded(
            child: _buildContentArea(context, ref, menuAsyncValue),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTabBar(BuildContext context, WidgetRef ref,
      AsyncValue<MenuState> menuAsyncValue) {
    return menuAsyncValue.when(
      data: (menuState) {
        if (menuState.openTabs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: const ShellTabBar(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildContentArea(BuildContext context, WidgetRef ref,
      AsyncValue<MenuState> menuAsyncValue) {
    return menuAsyncValue.when(
      data: (menuState) {
        if (menuState.activeTab == null) {
          return _buildWelcomePage(context);
        }

        return _buildTabContent(context, menuState.activeTab!);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              '内容加载失败',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/logo.png',
            width: 128,
            height: 128,
          ),
          const SizedBox(height: 24),
          Text(
            '欢迎使用 ApeVolo',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            '后台管理系统',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '快速开始',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildQuickStartItem(
                    context,
                    Icons.person,
                    '用户管理',
                    '管理系统用户和权限',
                  ),
                  const SizedBox(height: 12),
                  _buildQuickStartItem(
                    context,
                    Icons.settings,
                    '系统设置',
                    '配置系统参数和功能',
                  ),
                  const SizedBox(height: 12),
                  _buildQuickStartItem(
                    context,
                    Icons.dashboard,
                    '数据概览',
                    '查看系统运行状态',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartItem(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: 实现快速导航
        debugPrint('Quick navigate to: $title');
      },
    );
  }

  Widget _buildTabContent(BuildContext context, String tabId) {
    // 使用路由器根据tabId获取对应的页面
    return ShellRouter.getPageByTabId(tabId);
  }
}
