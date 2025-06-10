import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shell_provider.dart';
import '../widgets/shell_vertical_menu.dart';
import '../widgets/shell_content_area.dart';
import '../widgets/shell_horizontal_menu.dart';

/// Shell 主视图 - 应用的主要布局容器
class ShellView extends ConsumerWidget {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(shellProvider);
    final shellNotifier = ref.read(shellProvider.notifier);
    final menuAsyncValue = ref.watch(shellMenuProvider);

    // 添加调试信息
    menuAsyncValue.when(
      data: (menuState) {
        if (kDebugMode) {
          print('ShellView: 菜单加载成功，菜单数量: ${menuState.menus.length}');
        }
      },
      loading: () {
        if (kDebugMode) {
          print('ShellView: 菜单正在加载中...');
        }
      },
      error: (error, stack) {
        if (kDebugMode) {
          print('ShellView: 菜单加载失败: $error');
        }
      },
    );

    return Scaffold(
      body: Row(
        children: [
          // 左侧垂直菜单
          if (shellState.menuOpen)
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100.0),
              child: SizedBox(
                width: shellState.verticalMenuWidth,
                child: ShellVerticalMenu(
                  expandOpen: shellState.menuOpen,
                  onExpandMenu: shellNotifier.toggleMenu,
                ),
              ),
            ),

          // 菜单调整大小分隔线
          if (shellState.menuOpen)
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                onPanUpdate: (details) {
                  final newWidth =
                      shellState.verticalMenuWidth + details.delta.dx;
                  shellNotifier.setVerticalMenuWidth(newWidth);
                },
                onPanStart: (_) => shellNotifier.setResizeMouse(true),
                onPanEnd: (_) => shellNotifier.setResizeMouse(false),
                child: Container(
                  width: 5,
                  color: shellState.resizeMouse
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                      : Colors.transparent,
                  child: const VerticalDivider(
                    width: 5,
                    thickness: 1,
                  ),
                ),
              ),
            ),

          // 主内容区域
          Expanded(
            flex: 3,
            child: Card(
              margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Scaffold(
                body: Column(
                  children: [
                    // 水平菜单栏
                    menuAsyncValue.when(
                      data: (menuState) {
                        // 获取当前菜单信息用于显示标题
                        String? title;
                        String? subTitle;
                        String? iconPath;

                        if (menuState.activeTab != null) {
                          // 根据活动标签页查找对应的菜单信息
                          for (final menu in menuState.menus) {
                            if (menu.children != null) {
                              for (final child in menu.children!) {
                                if (child.component == menuState.activeTab ||
                                    child.name == menuState.activeTab) {
                                  title = menu.meta?.title;
                                  subTitle = child.meta?.title;
                                  iconPath = child.meta?.icon;
                                  break;
                                }
                              }
                            }
                            if (title != null) break;
                          }
                        }

                        return ShellHorizontalMenu(
                          title: title,
                          subTitle: subTitle,
                          svgIconPath: iconPath,
                          visible: !shellState.menuOpen,
                          onPressed: shellNotifier.toggleMenu,
                        );
                      },
                      loading: () => ShellHorizontalMenu(
                        visible: !shellState.menuOpen,
                        onPressed: shellNotifier.toggleMenu,
                      ),
                      error: (error, stack) => ShellHorizontalMenu(
                        visible: !shellState.menuOpen,
                        onPressed: shellNotifier.toggleMenu,
                      ),
                    ),

                    // 主要内容显示区域
                    const Expanded(
                      child: ShellContentArea(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // 悬浮操作按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 实现快速操作功能
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
