import 'dart:math';

import 'package:apevolo_flutter/app/modules/shell/controllers/shell_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_vertical_menu_controller.dart';
import 'package:apevolo_flutter/app/modules/shell/views/shell_menu_buttons_view.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellVerticalMenuView extends GetView {
  const ShellVerticalMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final ShellController shellController = Get.find();
    final GlobalKey personMenuKey = GlobalKey();
    return GetBuilder<ShellVerticalMenuController>(
      init: ShellVerticalMenuController(),
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
                    children: controller.menuList
                        .map(
                          (x) => ExpansionTile(
                            leading: Icon(getRandomIcon()),
                            title: Text(x.meta?.title ?? ''),
                            children: x.children == null
                                ? []
                                : x.children!.map((y) {
                                    IconData iconData = getRandomIcon();
                                    return ListTile(
                                      leading: Icon(iconData),
                                      title: Text(y.meta?.title ?? ''),
                                      onTap: () {
                                        if (y.path != null) {
                                          Get.toNamed('${x.path}/${y.path!}',
                                              id: 1);
                                        }
                                        //Get.toNamed(Routes.USER, id: 1);
                                        //controller.onChangeMenu(x, y, iconData);
                                      },
                                    );
                                  }).toList(),
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black12,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Icon(Icons.add),
                              Text('New Tab'),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('Item 1'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Item 2'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Item 3'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
