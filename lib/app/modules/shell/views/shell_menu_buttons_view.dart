import 'package:apevolo_flutter/app/components/theme_mode/views/theme_mode_view.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellMenuButtonsView extends GetView {
  const ShellMenuButtonsView({super.key, this.visible = false});

  final bool visible;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: OverflowBar(
        children: [
          // AnimatedContainer(
          //   duration: const Duration(seconds: 5),
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10), // Add border radius
          //     gradient: const LinearGradient(
          //       colors: [
          //         Colors.red,
          //         Colors.orange,
          //         Colors.yellow,
          //         Colors.green,
          //         Colors.blue,
          //         Colors.indigo,
          //         Colors.purple,
          //       ],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          //   padding: const EdgeInsets.only(left: 8, right: 8),
          //   child: const Text(
          //     'APEVOlO',
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //     textAlign: TextAlign.center,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('Selected:');
              }
            },
            tooltip: '个人中心',
            padding: EdgeInsets.zero,
            icon: PopupMenuButton(
              padding: EdgeInsets.zero,
              tooltip: '个人中心',
              icon: const Icon(Icons.person),
              onSelected: (value) {
                if (kDebugMode) {
                  print('Selected: $value');
                }
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
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message),
          ),
          const ThemeModeView(),
          IconButton(
            onPressed: () => Get.toNamed(Routes.SETTING, id: 1),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
