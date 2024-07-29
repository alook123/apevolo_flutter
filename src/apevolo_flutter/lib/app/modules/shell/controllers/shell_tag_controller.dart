import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_menu_controller.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ShellTagController extends GetxController {
  final ShellMenuController shellMenuController =
      Get.find<ShellMenuController>();

  final RxList<ChildrenMenu> openMenus = <ChildrenMenu>[].obs;

  Future<void> onTapMenu({
    required ChildrenMenu children,
    required String? tag,
    MenuBuild? menu,
  }) async {
    if (children.path == null) return;
    tag ??= const Uuid().v4();

    for (var element in openMenus) {
      element.selected = false;
    }
    children.selected = true;
    children.tag = tag;
    shellMenuController.tag.value = tag;
    menu ??= shellMenuController.menus
        .firstWhere((x) => x.children!.contains(children));
    update();
    await Get.toNamed(
      '${menu.path}/${children.path}',
      id: 1,
      arguments: tag,
      parameters: {'tag': tag},
    );
  }
}
