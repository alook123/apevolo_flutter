import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/theme_mode_controller.dart';

class ThemeModeView extends GetView<ThemeModeController> {
  const ThemeModeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModeController>(
      init: ThemeModeController(),
      builder: (controller) => IconButton(
        onPressed: () {
          controller.changeThemeMode();
        },
        icon: const Icon(Icons.light_mode),
      ),
    );
  }
}
