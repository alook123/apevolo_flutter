import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Scaffold(
          // appBar: AppBar(
          //   title: const Text('Setting'),
          //   centerTitle: true,
          // ),
          body: ListView(
            children: [
              const Text(
                'APEVOlO',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ListTile(
                title: const Text('语言'),
                subtitle: const Text('中文'),
                onTap: () {
                  //Get.toNamed('/setting/language');
                },
              ),
              ListTile(
                title: const Text('主题'),
                subtitle: Text(controller.themeModeText.value),
                onTap: () => controller.onChangeThemeMode(),
              ),
            ],
          ),
          bottomNavigationBar: AboutListTile(
            icon: Image.asset(
              'assets/image/logo.png',
              width: 26,
            ),
            applicationName: 'Apevolo_flutter',
            applicationVersion: '1.0.0',
            applicationIcon: Image.asset(
              'assets/image/logo.png',
              width: 100,
            ),
            applicationLegalese: '© 2024 Apevolo. All rights reserved.',
            aboutBoxChildren: const [
              Text('This is a sample Flutter app.'),
              SizedBox(height: 8.0),
              Text('Developed by My Company.'),
            ],
            dense: true,
          ),
        );
      },
    );
  }
}
