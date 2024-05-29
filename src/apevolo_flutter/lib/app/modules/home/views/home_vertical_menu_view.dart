import 'dart:math';

import 'package:apevolo_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:apevolo_flutter/app/modules/home/controllers/home_vertical_menu_controller.dart';
import 'package:apevolo_flutter/app/modules/widget/theme_mode/views/theme_mode_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeVerticalMenuView extends GetView {
  const HomeVerticalMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return GetBuilder<HomeVerticalMenuController>(
      init: HomeVerticalMenuController(),
      builder: (controller) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  homeController.menuOpen.value =
                      !homeController.menuOpen.value;
                  Get.back();
                },
                icon: Icon(
                  homeController.menuOpen.value
                      ? FluentIcons.panel_left_16_regular
                      : FluentIcons.panel_left_16_filled,
                ),
              ),
              Visibility(
                visible: homeController.menuOpen.value,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings),
                    ),
                    const ThemeModeView(),
                  ],
                ),
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
                                        controller.onChangeMenu(x, y, iconData);
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
