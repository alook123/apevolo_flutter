import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/components/views/svg_picture_view.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellMenuView extends GetView<ShellMenuController> {
  const ShellMenuView({
    super.key,
    required this.onTapMenuCallback,
  });

  /// 点击菜单事件
  final void Function(ChildrenMenu menu) onTapMenuCallback;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        return Column(
          children: [
            // const SizedBox(height: 8),
            Obx(() => Column(
                  children: controller.userService.menus
                      .map((x) => _buildMenuTile(context, x))
                      .toList(),
                )),
          ],
        );
      },
      onEmpty: const Text('菜单为空'),
      onError: (error) {
        return Text(
          '获取失败！$error',
          style: const TextStyle(color: Colors.red),
        );
      },
      onLoading: const LinearProgressIndicator(),
    );
  }

  // 提取菜单项构建函数以提高可读性和可维护性
  Widget _buildMenuTile(BuildContext context, MenuBuild menu) {
    return ExpansionTile(
      key: ValueKey('parent-${menu.meta?.title}'),
      leading: SvgPictureView(
        menu.meta?.icon,
        // 优化：使用key确保图标不会不必要地重建
        key: ValueKey('parent-icon-${menu.meta?.icon}'),
      ),
      title: Text(menu.meta?.title ?? ''),
      onExpansionChanged: (value) => controller.onExpansionChanged(value, menu),
      initiallyExpanded: menu.expanded ?? false,
      maintainState: true, // 保持子组件状态，减少重建
      children: menu.children
              ?.map(
                (childMenu) => _buildChildMenuTile(context, childMenu, menu),
              )
              .toList() ??
          [],
    );
  }

  // 提取子菜单项构建函数
  Widget _buildChildMenuTile(
      BuildContext context, ChildrenMenu childMenu, MenuBuild parentMenu) {
    return ListTile(
      key: ValueKey('child-${childMenu.meta?.title}'),
      leading: SvgPictureView(
        childMenu.meta?.icon,
        // 优化：使用key确保图标不会不必要地重建
        key: ValueKey('child-icon-${childMenu.meta?.icon}'),
      ),
      title: Text(childMenu.meta?.title ?? ''),
      onTap: () {
        controller.onTapMenu(children: childMenu, menu: parentMenu);
        onTapMenuCallback(childMenu);
      },
    );
  }
}
