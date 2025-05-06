import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_menu_controller.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ShellTagController extends GetxController {
  final UserService userService = Get.find<UserService>();

  final ShellMenuController shellMenuController =
      Get.find<ShellMenuController>();

  final Rx<bool> hoveredLine = false.obs;

  void onHoveredLine(bool value) {
    hoveredLine.value = value;
    update();
  }

  Future<void> onClearMenus() async {
    userService.openMenus.clear();
    update();
  }

  Future<void> onTapMenu({
    required ChildrenMenu children,
    MenuBuild? menu,
  }) async {
    if (children.path == null) return;

    // 使用 Freezed 的 copyWith 方法创建新的 ChildrenMenu 对象，设置 tag
    final tag = children.tag ?? const Uuid().v4();
    var updatedChildren = children.copyWith(tag: tag);

    // 将所有已打开菜单的选中状态设为 false
    final keys = userService.openMenus.keys.toList();
    for (var key in keys) {
      final element = userService.openMenus[key];
      if (element != null) {
        userService.openMenus[key] = element.copyWith(selected: false);
      }
    }

    // 更新当前菜单为选中状态
    updatedChildren = updatedChildren.copyWith(selected: true);

    // 如果没有提供菜单，则查找包含此子菜单的菜单
    menu ??= shellMenuController.userService.menus.singleWhere(
      (element) => element.children!
          .any((child) => child.component == updatedChildren.component),
    );

    // 更新openMenus中的菜单项
    if (tag != null) {
      userService.openMenus[tag] = updatedChildren;
    }

    update();
    Get.toNamed(
      '${menu.path}/${updatedChildren.path}',
      id: 1,
      arguments: tag,
      parameters: {'tag': tag},
    );
  }
}
