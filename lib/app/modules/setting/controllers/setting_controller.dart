import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final SystemService systemService = Get.find<SystemService>();
  final Rx<String> themeModeText = '浅色'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onChangeThemeMode() async {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    systemService.themeMode.value =
        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    themeModeText.value = Get.isDarkMode ? '浅色' : '深色';
    update();
  }
}
