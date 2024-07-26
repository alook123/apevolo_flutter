import 'dart:math';

import 'package:apevolo_flutter/app/modules/shell/controllers/shell_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_vertical_menu_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_buttons_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellVerticalMenuView extends GetView<ShellVerticalMenuController> {
  ShellVerticalMenuView({super.key});
  final ShellController shellController = Get.find();
  IconData getRandomIcon() {
    // MaterialIcons 字体库的第一个图标代码点
    int firstCodePoint = 0xE000;
    // MaterialIcons 字体库的最后一个图标代码点
    int lastCodePoint = 0xEB4B;
    // 随机生成一个代码点
    int randomCodePoint =
        firstCodePoint + Random().nextInt(lastCodePoint - firstCodePoint + 1);
    // 根据代码点创建一个图标
    return IconData(randomCodePoint, fontFamily: 'MaterialIcons');
  }

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
                  shellController.menuOpen.value =
                      !shellController.menuOpen.value;
                  Get.back();
                },
                icon: Icon(
                  shellController.menuOpen.value
                      ? FluentIcons.panel_left_16_regular
                      : FluentIcons.panel_left_16_filled,
                ),
              ),
              ShellMenuButtonsView(
                visible: shellController.menuOpen.value,
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    children: controller.menus
                        .map((x) => ExpansionTile(
                              leading: Icon(getRandomIcon()),
                              title: Text(x.meta?.title ?? ''),
                              children: x.children?.map((y) {
                                    IconData iconData = getRandomIcon();
                                    return ListTile(
                                      leading: Icon(iconData),
                                      title: Text(y.meta?.title ?? ''),
                                      onTap: () => controller.onTapMenu(y,
                                          menu: x, newTab: true),
                                    );
                                  }).toList() ??
                                  [],
                            ))
                        .toList(),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black12,
                    indent: 8,
                    endIndent: 8,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        Text('New Tab'),
                      ],
                    ),
                  ),
                  Column(
                    children: controller.openMenu.entries
                        .map((entry) {
                          return MapEntry(
                            key,
                            ListTile(
                              leading: const Icon(Icons.tab),
                              title: Text(entry.value.$1.meta?.title ?? ''),
                              onTap: () => controller.onTapMenu(
                                entry.value.$1,
                                tag: entry.key,
                                newTab: false,
                              ),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              selected: entry.value.$2,
                              enabled: true,
                            ),
                          );
                        })
                        .map((e) => e.value)
                        .toList(),
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
