import 'package:apevolo_flutter/app/modules/shell/controllers/shell_vertical_menu_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_buttons_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_navigation_menu_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_tag_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellVerticalMenuView extends GetView<ShellVerticalMenuController> {
  const ShellVerticalMenuView({
    super.key,
    this.onExpandMenu,
    this.expandOpen = false,
  });

  /// 是否展开菜单
  final bool expandOpen;

  /// 点击菜单展开回调
  final Function()? onExpandMenu;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShellVerticalMenuController>(
      init: controller,
      builder: (controller) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  onExpandMenu?.call();
                  //menuOpen = !menuOpen;
                  Get.back();
                },
                icon: Icon(
                  expandOpen
                      ? FluentIcons.panel_left_16_regular
                      : FluentIcons.panel_left_16_filled,
                ),
              ),
              ShellNavigationMenuView(
                visible: expandOpen,
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ShellMenuView(
                    onTapMenuCallback: (menu) => controller.onTapMenu(menu),
                  ),
                  ShellTagView(
                    onTapMenuCallback: (menu) => controller.onTapMenu(menu),
                  ),
                ],
              ),
            ),
          ),
          ShellMenuButtonsView(
            visible: expandOpen,
          ),
        ],
      ),
    );
  }
}
