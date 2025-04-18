import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_menu_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShellMenuView extends GetView<ShellMenuController> {
  const ShellMenuView({
    super.key,
    required this.onTapMenuCallback,
  });

  /// 点击菜单事件
  final void Function(ChildrenMenu menu) onTapMenuCallback;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        return Column(
          children: [
            // const SizedBox(height: 8),
            Column(
              children: controller.userService.menus
                  .map((x) => ExpansionTile(
                        leading: x.path == null
                            ? const Icon(Icons.error)
                            : Icon(controller.userService
                                .getIconData(x.path ?? '')),
                        title: Text(x.meta?.title ?? ''),
                        onExpansionChanged: (value) =>
                            controller.onExpansionChanged(value, x),
                        initiallyExpanded: x.expanded ?? false,
                        children: x.children?.map(
                              (y) {
                                return ListTile(
                                  leading: y.path == null
                                      ? const Icon(Icons.error)
                                      : Icon(controller.userService
                                          .getIconData(y.path ?? '')),
                                  title: Text(y.meta?.title ?? ''),
                                  onTap: () {
                                    controller.onTapMenu(children: y, menu: x);
                                    onTapMenuCallback(y);
                                  },
                                );
                              },
                            ).toList() ??
                            [],
                      ))
                  .toList(),
            ),
          ],
        );
      },
      onEmpty: const Text('菜单为空'),
      onError: (error) {
        return Text(
          '获取失败！$error',
          style: const TextStyle(color: Colors.red),
        );
      },
      onLoading: const LinearProgressIndicator(),
    );
  }
}
