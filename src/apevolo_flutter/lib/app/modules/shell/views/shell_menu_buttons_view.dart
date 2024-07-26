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
    return Visibility(
      visible: _visible,
      child: ButtonBar(
        alignment: MainAxisAlignment.end,
        buttonPadding: const EdgeInsets.all(0),
        // buttonTextTheme: ButtonTextTheme.primary,
        overflowButtonSpacing: 0,
        children: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.HOME, id: 1),
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message),
          ),
          // IconButton(
          //   key: personMenuKey,
          //   onPressed: () {
          //     final RenderBox box =
          //         personMenuKey.currentContext!.findRenderObject() as RenderBox;
          //     Offset position = box.localToGlobal(Offset.zero);
          //     Size size = box.size;
          //     showMenu(
          //       context: context,
          //       position: RelativeRect.fromLTRB(
          //         position.dx,
          //         position.dy + size.height,
          //         position.dx + size.width,
          //         position.dy,
          //       ),
          //       items: [
          //         PopupMenuItem(
          //           child: ListTile(
          //             leading: const Icon(Icons.account_box),
          //             title: const Text('个人资料'),
          //             onTap: () {},
          //           ),
          //         ),
          //         PopupMenuItem(
          //           child: ListTile(
          //             leading: const Icon(Icons.logout),
          //             title: const Text('注销'),
          //             onTap: () {
          //               controller.onLogout();
          //             },
          //           ),
          //         ),
          //       ],
          //       elevation: 8.0,
          //     );
          //   },
          //   icon: const Icon(Icons.person),
          // ),
          PopupMenuButton(
            tooltip: '个人中心',
            icon: const Icon(Icons.person),
            onSelected: (value) {
              // Handle the selected menu item
              print('Selected: $value');
            },
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
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
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.SETTING, id: 1),
            icon: const Icon(Icons.settings),
          ),
          const ThemeModeView(),
        ],
      ),
    );
  }
}
