import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class SystemService extends GetxService {
  final GetStorage _baseStorage = GetStorage();
  final ReadWriteValue<String> themeMode = 'system'.val('themeMode');
  //final ReadWriteValue<String?> selectMenu = 'system'.val('selectMenu');
  final Rx<ChildrenMenu?> selectMenu = ChildrenMenu().obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _loadThemeMode();
    _loadSelectMenu();
  }

  /// 加载用户信息
  void _loadSelectMenu() {
    final data = _baseStorage.read('selectMenu');
    if (data != null && data is Map<String, dynamic>) {
      selectMenu.value = ChildrenMenu.fromJson(data);
    }
    selectMenu.listen(
      (value) {
        _baseStorage.write('selectMenu', value);
      },
    );
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
