import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:apevolo_flutter/app/constants/about_constants.dart';

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
              AboutConstants.appIconPath,
              width: 26,
            ),
            applicationName: AboutConstants.appName,
            applicationVersion: AboutConstants.appVersion,
            applicationIcon: Image.asset(
              AboutConstants.appIconPath,
              width: 100,
            ),
            applicationLegalese: AboutConstants.appLegalese,
            aboutBoxChildren: [
              for (final description in AboutConstants.appDescription)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(description),
                ),
            ],
            dense: true,
          ),
        );
      },
    );
  }
}
