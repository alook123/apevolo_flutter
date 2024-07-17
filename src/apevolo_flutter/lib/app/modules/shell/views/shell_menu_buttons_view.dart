import 'package:apevolo_flutter/app/modules/components/theme_mode/views/theme_mode_view.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellMenuButtonsView extends GetView {
  ShellMenuButtonsView({
    super.key,
    bool visible = true,
  }) {
    _visible = visible;
  }

  late final bool _visible;
  @override
  Widget build(BuildContext context) {
    final GlobalKey personMenuKey = GlobalKey();
    return Visibility(
      visible: _visible,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.HOME), //todo:修改成嵌套切换
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message),
          ),
          IconButton(
            key: personMenuKey,
            onPressed: () {
              final RenderBox box =
                  personMenuKey.currentContext!.findRenderObject() as RenderBox;
              Offset position = box.localToGlobal(Offset.zero);
              Size size = box.size;
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  position.dx,
                  position.dy + size.height,
                  position.dx + size.width,
                  position.dy,
                ),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.account_box),
                      title: const Text('个人资料'),
                      onTap: () {},
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('注销'),
                      onTap: () {
                        controller.onLogout();
                      },
                    ),
                  ),
                ],
                elevation: 8.0,
              );
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          const ThemeModeView(),
        ],
      ),
    );
  }
}
