import 'package:apevolo_flutter/app/modules/shell/controllers/shell_tag_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellTagView extends GetView<ShellTagController> {
  const ShellTagView({
    super.key,
    required this.getIconData,
  });
  final IconData Function(String path) getIconData;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Column(
          children: [
            //todo: 放到菜单栏后，显示清楚全部标签的按钮
            const Divider(
              height: 2,
              color: Colors.black12,
              indent: 8,
              endIndent: 8,
            ),
            Column(
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
              ],
            ),
            Column(
              children: controller.openMenus
                  .map((entry) {
                    return MapEntry(
                      key,
                      ListTile(
                        leading: entry.path == null
                            ? const Icon(Icons.error)
                            : Icon(getIconData(entry.path!)),
                        title: Text(entry.meta?.title ?? ''),
                        onTap: () => controller.onTapMenu(
                          children: entry,
                          tag: entry.tag,
                        ),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        selected: entry.selected == true,
                        enabled: true,
                      ),
                    );
                  })
                  .map((e) => e.value)
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
