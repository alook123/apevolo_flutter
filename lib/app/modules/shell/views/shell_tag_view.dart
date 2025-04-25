import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/modules/components/views/svg_picture_view.dart';
import 'package:apevolo_flutter/app/modules/shell/controllers/shell_tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ShellTagView extends GetView<ShellTagController> {
  const ShellTagView({
    super.key,
    required this.onTapMenuCallback,
  });

  /// 点击菜单事件
  final void Function(ChildrenMenu menu) onTapMenuCallback;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Column(
          children: [
            MouseRegion(
              onEnter: (_) => controller.onHoveredLine(true),
              onExit: (_) => controller.onHoveredLine(false),
              child: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 18,
                    ),
                    child: Divider(
                      height: 2,
                      color: Colors.black12,
                      indent: 8,
                      endIndent: 8,
                    ),
                  ),
                  if (controller.hoveredLine.value)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('整理'),
                          ),
                          TextButton(
                            onPressed: () {
                              // 触发清除效果
                              print('Clear action triggered');
                              controller.onClearMenus();
                            },
                            child: const Text('清除'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
              children: controller.userService.openMenus.entries
                  .map((entry) {
                    return MapEntry(
                      entry.key,
                      ListTile(
                        leading: SvgPictureView(
                          entry.value.path,
                        ),
                        title: Text(entry.value.meta?.title ?? ''),
                        onTap: () {
                          onTapMenuCallback(entry.value);
                          controller.onTapMenu(
                            children: entry.value,
                          );
                        },
                        // selectedColor: Theme.of(context).colorScheme.primary,
                        selected: entry.value.selected == true,
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
