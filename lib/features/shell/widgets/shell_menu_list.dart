import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../network/apevolo_com/models/menu/menu_build_model.dart';
import '../../../shared/widgets/svg_picture_view.dart';
import '../providers/shell_provider.dart';

/// 菜单列表组件
class ShellMenuList extends ConsumerWidget {
  final List<MenuBuild> menus;
  final bool expandOpen;

  const ShellMenuList({
    super.key,
    required this.menus,
    required this.expandOpen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print(
          'ShellMenuList: 构建中，菜单数量: ${menus.length}, expandOpen: $expandOpen');
    }

    if (menus.isEmpty) {
      if (kDebugMode) {
        print('ShellMenuList: 菜单为空，显示暂无菜单数据');
      }
      return const Center(
        child: Text('暂无菜单数据'),
      );
    }

    return ListView.builder(
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return _buildMenuItem(context, ref, menu);
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, WidgetRef ref, MenuBuild menu) {
    final hasChildren = menu.children?.isNotEmpty ?? false;

    if (!expandOpen) {
      // 收起状态：只显示图标
      return _buildCollapsedMenuItem(context, ref, menu);
    }

    // 展开状态：显示完整菜单
    if (hasChildren) {
      return _buildExpandableMenuItem(context, ref, menu);
    } else {
      return _buildSimpleMenuItem(context, ref, menu);
    }
  }

  /// 构建可展开的菜单项（父菜单）
  Widget _buildExpandableMenuItem(
      BuildContext context, WidgetRef ref, MenuBuild menu) {
    return ExpansionTile(
      key: ValueKey('parent-${menu.meta?.title}'),
      leading: SvgPictureView(
        menu.meta?.icon,
        width: 20,
        height: 20,
      ),
      title: Text(
        menu.meta?.title ?? menu.name ?? '',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      initiallyExpanded: menu.expanded ?? false,
      maintainState: true,
      onExpansionChanged: (expanded) {
        ref
            .read(shellMenuProvider.notifier)
            .toggleMenuExpansion(menu, expanded);
      },
      children: menu.children
              ?.map((childMenu) =>
                  _buildChildMenuItem(context, ref, childMenu, menu))
              .toList() ??
          [],
    );
  }

  /// 构建简单菜单项（无子菜单）
  Widget _buildSimpleMenuItem(
      BuildContext context, WidgetRef ref, MenuBuild menu) {
    return ListTile(
      leading: SvgPictureView(
        menu.meta?.icon,
        width: 20,
        height: 20,
      ),
      title: Text(
        menu.meta?.title ?? menu.name ?? '',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () {
        _handleMenuItemTap(context, ref, menu.name ?? '');
      },
    );
  }

  /// 构建子菜单项
  Widget _buildChildMenuItem(BuildContext context, WidgetRef ref,
      ChildrenMenu childMenu, MenuBuild parentMenu) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: SvgPictureView(
        childMenu.meta?.icon,
        width: 16,
        height: 16,
      ),
      title: Text(
        childMenu.meta?.title ?? childMenu.name ?? '',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      onTap: () {
        _handleChildMenuItemTap(context, ref, childMenu);
      },
    );
  }

  /// 构建收起状态的菜单项
  Widget _buildCollapsedMenuItem(
      BuildContext context, WidgetRef ref, MenuBuild menu) {
    return Tooltip(
      message: menu.meta?.title ?? menu.name ?? '',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: IconButton(
          icon: SvgPictureView(
            menu.meta?.icon,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            if (menu.children?.isNotEmpty ?? false) {
              ref.read(shellProvider.notifier).toggleMenu();
            } else {
              _handleMenuItemTap(context, ref, menu.name ?? '');
            }
          },
        ),
      ),
    );
  }

  void _handleChildMenuItemTap(
      BuildContext context, WidgetRef ref, ChildrenMenu childMenu) {
    final tabId = childMenu.component ?? childMenu.name ?? '';

    if (tabId.isNotEmpty) {
      ref.read(shellMenuProvider.notifier).addTab(tabId);
    }
  }

  void _handleMenuItemTap(BuildContext context, WidgetRef ref, String menuId) {
    // 所有菜单项都使用标签页处理，包括设置
    if (menuId.isNotEmpty) {
      ref.read(shellMenuProvider.notifier).addTab(menuId);
    }
  }
}
