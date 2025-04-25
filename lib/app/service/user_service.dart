import 'dart:math';

import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

class UserService extends GetxService {
  final GetStorage _userStorage = GetStorage('userData');
  final Rxn<AuthLogin> loginInfo = Rxn<AuthLogin>();
  final RxMap<String?, String> menuSvgPaths = <String?, String>{}.obs;

  ///菜单
  final RxList<MenuBuild> menus = <MenuBuild>[].obs;

  ///打开过的菜单
  final RxMap<String, ChildrenMenu> openMenus = <String, ChildrenMenu>{}.obs;

  final Rxn<ChildrenMenu> currentMenu = Rxn<ChildrenMenu>();

  final ReadWriteValue<String?> openTag = null.val(
    'userData',
    getBox: () => GetStorage('userData'),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    await loadUserInfo();
    await loadOpenMenu();
  }

  /// 加载用户信息
  Future<void> loadUserInfo() async {
    final data = _userStorage.read('loginInfo');
    if (data != null) loginInfo.value = AuthLogin.fromJson(data);
    loginInfo.listen(
      (value) async {
        await _userStorage.write('loginInfo', value);
      },
    );
  }

  /// 加载打开的菜单
  Future<void> loadOpenMenu() async {
    final data = _userStorage.read('openMenus');
    if (data != null) {
      openMenus.value = data.map<String, ChildrenMenu>((key, value) =>
          MapEntry<String, ChildrenMenu>(key, ChildrenMenu.fromJson(value)));
    }
    openMenus.listen(
      (value) {
        _userStorage.write('openMenus', value);
        if (value.isNotEmpty) {
          currentMenu.value = value.values.last;
        }
      },
    );
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    await _userStorage.remove('loginInfo');
    await _userStorage.remove('openMenus');
    loginInfo.value = null;
    openMenus.clear();
  }

  /// 获取SVG图标路径
  String getSvgIconPath(String? path) {
    if (path == null || menuSvgPaths[path] == null) {
      // 默认图标
      String defaultIconPath = 'assets/svg/dashboard.svg';

      if (path != null) {
        // 提取路径中的最后一部分作为可能的图标名称
        String fileName = path.split('/').last.toLowerCase();

        // 尝试几种可能的图标匹配方式：
        // 1. 直接匹配 (例如 'user' -> 'user.svg')
        // 2. 相关名称匹配 (例如 'user_management' -> 'user.svg')

        // 常见路径模式与图标的映射
        final Map<String, String> commonPatterns = {
          'dashboard': 'dashboard.svg',
          'home': 'dashboard.svg',
          'system': 'system.svg',
          'user': 'user.svg',
          'role': 'role.svg',
          'menu': 'menu.svg',
          'log': 'log.svg',
          'monitor': 'monitor.svg',
          'setting': 'setting.svg',
          'tool': 'tools.svg',
          'list': 'list.svg',
          'api': 'api.svg',
          'app': 'app.svg',
          'database': 'database.svg',
        };

        // 查找精确匹配
        if (menuSvgPaths[path] == null) {
          // 1. 尝试直接匹配文件名
          final exactMatch = 'assets/svg/$fileName.svg';
          final exactMatchNoExt = 'assets/svg/$fileName';

          // 2. 尝试从常见模式映射中查找
          for (var entry in commonPatterns.entries) {
            if (fileName.contains(entry.key)) {
              menuSvgPaths[path] = 'assets/svg/${entry.value}';
              break;
            }
          }

          // 3. 如果还未找到匹配，尝试单词匹配
          if (menuSvgPaths[path] == null) {
            for (var keyword in fileName.split(RegExp(r'[_\-\s]'))) {
              if (commonPatterns.containsKey(keyword)) {
                menuSvgPaths[path] = 'assets/svg/${commonPatterns[keyword]}';
                break;
              }
            }
          }

          // 如果以上都没有匹配到，使用默认图标
          menuSvgPaths[path] ??= defaultIconPath;
        }
      } else {
        // 路径为空，使用默认图标
        menuSvgPaths[path] = defaultIconPath;
      }
    }

    return menuSvgPaths[path]!;
  }
}
