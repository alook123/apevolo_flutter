import 'dart:convert';
import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  final SharedPrefsStorageService _storage;
  final Rxn<AuthLogin> loginInfo = Rxn<AuthLogin>();
  final RxMap<String?, String> menuSvgPaths = <String?, String>{}.obs;

  ///菜单
  final RxList<MenuBuild> menus = <MenuBuild>[].obs;

  ///打开过的菜单
  final RxMap<String, ChildrenMenu> openMenus = <String, ChildrenMenu>{}.obs;

  final Rxn<ChildrenMenu> currentMenu = Rxn<ChildrenMenu>();

  final Rx<String?> openTag = Rx<String?>(null);

  UserService(this._storage);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    await loadUserInfo();
    await loadOpenMenu();
    await loadOpenTag();
  }

  /// 加载用户信息
  Future<void> loadUserInfo() async {
    final loginData =
        _storage.getObject('userData.loginInfo', AuthLogin.fromJson);
    if (loginData != null) loginInfo.value = loginData;

    loginInfo.listen(
      (value) async {
        if (value != null) {
          await _storage.saveObject('userData.loginInfo', value);
        }
      },
    );
  }

  /// 加载打开的菜单
  Future<void> loadOpenMenu() async {
    // 由于 openMenus 是复杂的 Map 结构，我们将其序列化为 JSON 字符串存储
    final jsonString = _storage.getString('userData.openMenus');
    if (jsonString != null) {
      try {
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final Map<String, ChildrenMenu> menuMap = {};
        data.forEach((key, value) {
          menuMap[key] = ChildrenMenu.fromJson(value);
        });
        openMenus.value = menuMap;
      } catch (e) {
        // 如果解析失败，清空数据
        openMenus.clear();
      }
    }

    openMenus.listen(
      (value) async {
        final Map<String, dynamic> serialized = {};
        value.forEach((key, menu) {
          serialized[key] = menu.toJson();
        });
        await _storage.setString('userData.openMenus', jsonEncode(serialized));

        if (value.isNotEmpty) {
          currentMenu.value = value.values.last;
        }
      },
    );
  }

  /// 加载打开的标签
  Future<void> loadOpenTag() async {
    final tag = _storage.getString('userData.openTag');
    openTag.value = tag;

    openTag.listen((value) async {
      if (value != null) {
        await _storage.setString('userData.openTag', value);
      } else {
        await _storage.remove('userData.openTag');
      }
    });
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    await _storage.remove('userData.loginInfo');
    await _storage.remove('userData.openMenus');
    await _storage.remove('userData.openTag');
    loginInfo.value = null;
    openMenus.clear();
    openTag.value = null;
  }
}
