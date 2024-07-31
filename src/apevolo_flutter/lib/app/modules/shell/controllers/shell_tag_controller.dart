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
    children.tag ??= const Uuid().v4();

    for (var element in userService.openMenus.values) {
      element.selected = false;
    }
    children.selected = true;
    menu ??= shellMenuController.menus.singleWhere(
      (element) => element.children!
          .any((child) => child.component == children.component),
    );

    update();
    Get.toNamed(
      '${menu.path}/${children.path}',
      id: 1,
      arguments: children.tag,
      parameters: {'tag': children.tag!},
    );
  }
}
