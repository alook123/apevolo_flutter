import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shell_state.dart';
import '../providers/shell_provider.dart';
import '../utils/shell_router.dart';

/// Shell 标签栏组件
/// 显示打开的标签页列表，支持分隔线悬停操作
class ShellTabBar extends ConsumerStatefulWidget {
  const ShellTabBar({super.key});

  @override
  ConsumerState<ShellTabBar> createState() => _ShellTabBarState();
}

class _ShellTabBarState extends ConsumerState<ShellTabBar> {
  bool _hoveredLine = false;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(shellMenuProvider);

    return menuState.when(
      data: (state) => Column(
        children: [
          // 分隔线和操作按钮
          _buildDividerWithActions(),

          // 新建标签按钮
          _buildNewTabButton(),

          // 标签页列表
          Expanded(
            child: _buildTabList(state),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('标签页加载失败: $error'),
      ),
    );
  }

  /// 构建分隔线和操作按钮
  Widget _buildDividerWithActions() {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredLine = true),
      onExit: (_) => setState(() => _hoveredLine = false),
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            child: Divider(
              height: 2,
              color: Colors.black12,
              indent: 8,
              endIndent: 8,
            ),
          ),
          if (_hoveredLine)
            Positioned(
              right: 8,
              top: 8,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: 实现标签页整理功能
                    },
                    child: const Text('整理'),
                  ),
                  TextButton(
                    onPressed: () {
                      // 清除所有标签页
                      _clearAllTabs();
                    },
                    child: const Text('清除'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 构建新建标签按钮
  Widget _buildNewTabButton() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // TODO: 实现新建标签页功能
          },
          child: const Row(
            children: [
              Icon(Icons.add),
              Text('New Tab'),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建标签页列表
  Widget _buildTabList(MenuState state) {
    if (state.openTabs.isEmpty) {
      return const Center(
        child: Text(
          '暂无打开的标签页',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.openTabs.length,
      itemBuilder: (context, index) {
        final tabId = state.openTabs[index];
        final isActive = tabId == state.activeTab;

        return _buildTabItem(context, tabId, isActive);
      },
    );
  }

  /// 构建单个标签页项
  Widget _buildTabItem(BuildContext context, String tabId, bool isActive) {
    return ListTile(
      leading: Icon(ShellRouter.getPageIcon(tabId)),
      title: Text(ShellRouter.getPageTitle(tabId)),
      selected: isActive,
      onTap: () {
        // 激活标签页
        ref.read(shellMenuProvider.notifier).setActiveTab(tabId);
      },
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 16),
        onPressed: () {
          // 关闭标签页
          ref.read(shellMenuProvider.notifier).closeTab(tabId);
        },
      ),
    );
  }

  /// 清除所有标签页
  void _clearAllTabs() {
    final menuState = ref.read(shellMenuProvider).valueOrNull;
    if (menuState == null) return;

    // 逐个关闭所有标签页
    for (final tabId in List.from(menuState.openTabs)) {
      ref.read(shellMenuProvider.notifier).closeTab(tabId);
    }
  }
}
