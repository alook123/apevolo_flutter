import 'dart:convert';

import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api/menu/menu_provider.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ShellMenuController extends GetxController with StateMixin {
  final UserService userService = Get.find<UserService>();
  final MenuProvider menuProvider = Get.find<MenuProvider>();

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

  ///加载菜单
  Future<void> onLoadMenu() async {
    menuProvider.build().then((value) {
      userService.menus.value = value;
      // for (var element in userService.menus) {
      //   userService.getSvgIconPath(element.path ?? '');
      //   for (var element2 in element.children ?? []) {
      //     userService.getSvgIconPath(element2.path ?? '');
      //   }
      // }
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
    userService.menus.firstWhere((x) => x == menu).expanded = value;
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
    for (var element in userService.openMenus.values) {
      element.selected = false;
    }
    if (userService.openMenus.values.contains(children)) {
      String newObjectStr = jsonEncode(children);
      children = ChildrenMenu.fromJson(jsonDecode(newObjectStr));
    }
    children.tag = tag;
    children.selected = true;
    userService.openMenus[tag] = children;
    await Get.toNamed(
      '${menu.path}/${children.path}',
      id: 1,
      arguments: tag,
      parameters: {'tag': tag},
    );
  }
}
