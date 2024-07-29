import 'dart:math';

import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

class UserService extends GetxService {
  final GetStorage _userStorage = GetStorage('userData');
  final Rxn<AuthLogin> loginInfo = Rxn<AuthLogin>();
  final RxMap<String, IconData> menuIconDatas = <String, IconData>{}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    //await loadUserInfo();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    await loadUserInfo();
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

  IconData getIconData(String path) {
    if (menuIconDatas[path] == null) {
      // MaterialIcons 字体库的第一个图标代码点
      int firstCodePoint = 0xE000;
      // MaterialIcons 字体库的最后一个图标代码点
      int lastCodePoint = 0xEB4B;
      // 随机生成一个代码点
      int randomCodePoint =
          firstCodePoint + Random().nextInt(lastCodePoint - firstCodePoint + 1);
      // 根据代码点创建一个图标
      IconData data = IconData(randomCodePoint, fontFamily: 'MaterialIcons');
      // 缓存起来
      menuIconDatas[path] = data;
    }
    return menuIconDatas[path]!;
  }
}
