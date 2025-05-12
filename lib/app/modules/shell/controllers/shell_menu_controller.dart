import 'dart:convert';

import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/modules/menu_rest_client.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ShellMenuController extends GetxController with StateMixin {
  final UserService userService = Get.find<UserService>();
  final MenuRestClient menuRestClient = Get.find<MenuRestClient>();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onLoadMenu();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 加载菜单
  Future<void> onLoadMenu() async {
    menuRestClient.build().then((value) {
      userService.menus.value = value;
      change(userService.menus, status: RxStatus.success());
    }).onError((error, stackTrace) {
      Logger.write('error:$error');
      change(null, status: RxStatus.error(error.toString()));
      if (kDebugMode) {
        Get.defaultDialog(title: '错误', middleText: error.toString());
      }
    });
  }

  /// 切换菜单展开状态
  Future<void> onExpansionChanged(bool value, MenuBuild menu) async {
    // 使用Freezed的copyWith方法直接创建新对象
    final index = userService.menus.indexWhere((x) => x == menu);
    if (index != -1) {
      userService.menus[index] = menu.copyWith(expanded: value);
    }
  }

  /// 点击菜单事件
  Future<void> onTapMenu({
    required ChildrenMenu children,
    MenuBuild? menu,
  }) async {
    if (children.path == null) return;
    String tag = const Uuid().v4();
    menu ??=
        userService.menus.firstWhere((x) => x.children!.contains(children));

    // 将所有已打开菜单的选中状态设为false
    final keys = userService.openMenus.keys.toList();
    for (var key in keys) {
      final menuItem = userService.openMenus[key];
      if (menuItem != null) {
        userService.openMenus[key] = menuItem.copyWith(selected: false);
      }
    }

    // 检查菜单是否已经打开
    if (userService.openMenus.values.contains(children)) {
      // 使用深拷贝创建一个新对象
      String newObjectStr = jsonEncode(children);
      children = ChildrenMenu.fromJson(jsonDecode(newObjectStr));
    }

    // 使用Freezed的copyWith方法创建新对象并添加到openMenus
    final updatedChildren = children.copyWith(tag: tag, selected: true);
    userService.openMenus[tag] = updatedChildren;

    await Get.toNamed(
      '${menu.path}/${updatedChildren.path}',
      id: 1,
      arguments: tag,
      parameters: {'tag': tag},
    );
  }
}
