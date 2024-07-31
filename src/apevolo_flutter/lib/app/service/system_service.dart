import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class SystemService extends GetxService {
  final ReadWriteValue<String> themeMode = 'system'.val('themeMode');
  //final ReadWriteValue<String?> selectMenu = 'system'.val('selectMenu');
  //final Rx<ChildrenMenu?> selectMenu = ChildrenMenu().obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _loadThemeMode();
  }

  void _loadThemeMode() {
    switch (themeMode.val) {
      case 'light':
        Get.changeThemeMode(ThemeMode.light);
      case 'dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'system':
      default:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }
}
