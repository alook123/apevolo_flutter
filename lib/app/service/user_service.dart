import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/service/storage/hive_storage_service.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  final HiveStorageService _storage;
  final String _userBoxName = 'userData';
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
    final data = _storage.read<Map<String, dynamic>>(_userBoxName, 'loginInfo');
    if (data != null) loginInfo.value = AuthLogin.fromJson(data);
    loginInfo.listen(
      (value) async {
        if (value != null) {
          await _storage.write(_userBoxName, 'loginInfo', value.toJson());
        }
      },
    );
  }

  /// 加载打开的菜单
  Future<void> loadOpenMenu() async {
    final data = _storage.read<Map<String, dynamic>>(_userBoxName, 'openMenus');
    if (data != null) {
      final Map<String, ChildrenMenu> menuMap = {};
      data.forEach((key, value) {
        menuMap[key] = ChildrenMenu.fromJson(value);
      });
      openMenus.value = menuMap;
    }

    openMenus.listen(
      (value) {
        final Map<String, dynamic> serialized = {};
        value.forEach((key, menu) {
          serialized[key] = menu.toJson();
        });
        _storage.write(_userBoxName, 'openMenus', serialized);

        if (value.isNotEmpty) {
          currentMenu.value = value.values.last;
        }
      },
    );
  }

  /// 加载打开的标签
  Future<void> loadOpenTag() async {
    final tag = _storage.read<String>(_userBoxName, 'openTag');
    openTag.value = tag;

    openTag.listen((value) {
      if (value != null) {
        _storage.write(_userBoxName, 'openTag', value);
      } else {
        _storage.delete(_userBoxName, 'openTag');
      }
    });
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    await _storage.delete(_userBoxName, 'loginInfo');
    await _storage.delete(_userBoxName, 'openMenus');
    await _storage.delete(_userBoxName, 'openTag');
    loginInfo.value = null;
    openMenus.clear();
    openTag.value = null;
  }
}
