import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeModeController extends GetxController {
  final SystemService _systemService = Get.find<SystemService>();

  ///主题
  final RxString theme = 'system'.obs;

  final GetStorage storage = GetStorage();
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

  Future<void> changeThemeMode() async {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }

    String value = Get.isDarkMode ? 'light' : 'dark';

    theme.value = value;
    _systemService.themeMode.val = value;

    update();
  }
}
