import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeModeController extends GetxController {
  final SystemService _systemService = Get.find<SystemService>();

  ///主题
  final RxString theme = 'system'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // 根据当前实际主题模式设置
    String value = Get.isDarkMode ? 'dark' : 'light';
    theme.value = value;
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> changeThemeMode() async {
    // 切换主题模式
    if (Get.isDarkMode) {
      _systemService.themeMode.value = ThemeMode.light;
    } else {
      _systemService.themeMode.value = ThemeMode.dark;
    }

    // 更新本地状态
    String value = Get.isDarkMode ? 'dark' : 'light';
    theme.value = value;
    update();
  }
}
