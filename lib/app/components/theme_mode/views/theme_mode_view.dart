import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/theme_mode_controller.dart';

class ThemeModeView extends GetView<ThemeModeController> {
  const ThemeModeView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModeController>(
      init: controller,
      builder: (controller) => IconButton(
        onPressed: () {
          controller.changeThemeMode();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        ),
      ),
    );
  }
}
