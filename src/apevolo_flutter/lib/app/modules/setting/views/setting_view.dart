import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('语言'),
            subtitle: const Text('中文'),
            onTap: () {
              //Get.toNamed('/setting/language');
            },
          ),
          ListTile(
            title: const Text('主题'),
            subtitle: const Text('深色'),
            onTap: () {
              // Get.toNamed('/setting/theme');
            },
          ),
          ListTile(
            title: const Text('关于'),
            subtitle: const Text('Apevolo_flutter'),
            onTap: () {
              // Get.toNamed('/setting/about');
              showAboutDialog(
                context: context,
                applicationName: 'Apevolo_flutter',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset(
                  'assets/image/logo.png',
                  width: 100,
                ),
                applicationLegalese: '© 2024 Apevolo. All rights reserved.',
              );
            },
          )
        ],
      ),
    );
  }
}
