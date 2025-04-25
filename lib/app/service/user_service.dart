import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
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
}
