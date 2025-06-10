import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../providers/shell_provider.dart';
import 'shell_menu_list.dart';
import 'shell_tab_bar.dart';
import 'shell_navigation_menu.dart';
import 'shell_menu_buttons.dart';

/// 垂直菜单组件
class ShellVerticalMenu extends ConsumerWidget {
  final bool expandOpen;
  final VoidCallback onExpandMenu;

  const ShellVerticalMenu({
    super.key,
    required this.expandOpen,
    required this.onExpandMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsyncValue = ref.watch(shellMenuProvider);

    return Card(
      margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      child: Column(
        children: [
          // 顶部工具栏
          _buildTopToolbar(context),

          // 菜单内容区域
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                children: [
                  // 菜单列表
                  Expanded(
                    flex: 2,
                    child: menuAsyncValue.when(
                      data: (menuState) {
                        if (kDebugMode) {
                          print(
                              'ShellVerticalMenu: 菜单数据 - 数量: ${menuState.menus.length}');
                        }
                        return ShellMenuList(
                          menus: menuState.menus,
                          expandOpen: expandOpen,
                        );
                      },
                      loading: () {
                        if (kDebugMode) {
                          print('ShellVerticalMenu: 菜单正在加载中...');
                        }
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text('正在加载菜单...'),
                            ],
                          ),
                        );
                      },
                      error: (error, stack) {
                        if (kDebugMode) {
                          print('ShellVerticalMenu: 菜单加载失败: $error');
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '菜单加载失败',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(shellMenuProvider.notifier)
                                      .refresh();
                                },
                                child: const Text('重试'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // 标签页区域
                  const Expanded(
                    flex: 1,
                    child: ShellTabBar(),
                  ),
                ],
              ),
            ),
          ),

          // 底部按钮区域
          ShellMenuButtons(
            visible: expandOpen,
          ),
        ],
      ),
    );
  }

  /// 构建顶部工具栏
  Widget _buildTopToolbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 菜单折叠按钮
        IconButton(
          onPressed: onExpandMenu,
          icon: Icon(
            expandOpen
                ? FluentIcons.panel_left_16_regular
                : FluentIcons.panel_left_16_filled,
          ),
          tooltip: expandOpen ? '收起菜单' : '展开菜单',
        ),

        // 导航菜单（在展开时显示）
        ShellNavigationMenu(
          visible: expandOpen,
        ),
      ],
    );
  }
}
