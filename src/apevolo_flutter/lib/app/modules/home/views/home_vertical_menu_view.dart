import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeVerticalMenuView extends GetView {
  HomeVerticalMenuView({Key? key, Function()? onPressed}) : super(key: key) {
    _onPressed = onPressed;
  }
  late final Function()? _onPressed;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _onPressed,
              icon: const Icon(Icons.menu_sharp),
            ),
            Row(
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
                IconButton(
                  onPressed: () {
                    Get.changeThemeMode(ThemeMode.dark);
                  },
                  icon: const Icon(Icons.light_mode),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Column(
                  children: [
                    ExpansionTile(
                      leading: Icon(Icons.ac_unit_sharp),
                      title: Text("1"),
                      children: [
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                        ListTile(
                          title: Text('Item 1'),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.ac_unit_sharp),
                      title: Text("1"),
                      children: [
                        ListTile(
                          title: Text('Item 1'),
                        )
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.ac_unit_sharp),
                      title: Text("1"),
                      children: [
                        ListTile(
                          title: Text('Item 1'),
                        )
                      ],
                    ),
                  ],
                ),

                //加一条横行的分割线
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
}
