import 'package:apevolo_flutter/app/data/models/auth_login_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

class UserService extends GetxService {
  final GetStorage _userStorage = GetStorage('userData');
  final Rxn<AuthLogin> loginInfo = Rxn<AuthLogin>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init('userData');

    _loadUserInfo();
  }

  /// 加载用户信息
  void _loadUserInfo() {
    final data = _userStorage.read('loginInfo');
    if (data != null) loginInfo.value = AuthLogin.fromJson(data);
    loginInfo.listen(
      (value) {
        _userStorage.write('loginInfo', value);
      },
    );
  }
}
