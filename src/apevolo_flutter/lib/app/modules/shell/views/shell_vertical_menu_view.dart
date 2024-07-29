import 'package:apevolo_flutter/app/modules/shell/controllers/shell_vertical_menu_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_buttons_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_view.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_tag_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellVerticalMenuView extends GetView<ShellVerticalMenuController> {
  const ShellVerticalMenuView({
    super.key,
    required this.getIconData,
  });

  final IconData Function(String path) getIconData;

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
                  controller.shellController.menuOpen.value =
                      !controller.shellController.menuOpen.value;
                  Get.back();
                },
                icon: Icon(
                  controller.shellController.menuOpen.value
                      ? FluentIcons.panel_left_16_regular
                      : FluentIcons.panel_left_16_filled,
                ),
              ),
              ShellMenuButtonsView(
                visible: controller.shellController.menuOpen.value,
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
                    onMenuTap: (menu) => controller.onTapMenu(menu),
                    getIconData: (path) => getIconData(path),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black12,
                    indent: 8,
                    endIndent: 8,
                  ),
                  ShellTagView(
                    getIconData: getIconData,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
