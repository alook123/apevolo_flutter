import 'dart:math';

import 'package:apevolo_flutter/app/data/models/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/widget/theme_mode/views/theme_mode_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeVerticalMenuView extends GetView {
  HomeVerticalMenuView(List<MenuBuild> menuList,
      {super.key, bool hiddenTopMenu = false, Function()? onPressed}) {
    _menuList = menuList;
    _hiddenTopMenu = hiddenTopMenu;
    _onPressed = onPressed;
  }
  late final List<MenuBuild> _menuList;
  late final bool _hiddenTopMenu;
  late final Function()? _onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _onPressed,
              icon: const Icon(Icons.menu_sharp),
            ),
            Visibility(
              visible: !_hiddenTopMenu,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FluentIcons.pin_12_filled),
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
                    icon: const Icon(Icons.settings_outlined),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     Get.changeThemeMode(ThemeMode.dark);
                  //   },
                  //   icon: const Icon(Icons.light_mode),
                  // ),
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
                  children: _menuList
                      .map(
                        (e) => ExpansionTile(
                          leading: Icon(getRandomIcon()),
                          title: Text(e.meta?.title ?? ''),
                          children: e.children == null
                              ? []
                              : e.children!
                                  .map(
                                    (e) => ListTile(
                                      leading: Icon(getRandomIcon()),
                                      title: Text(e.meta?.title ?? ''),
                                      onTap: () {},
                                    ),
                                  )
                                  .toList(),
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
