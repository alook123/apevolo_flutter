import 'package:apevolo_flutter/app/controllers/auth_controller.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:get/get.dart';

/// 认证控制器绑定
///
/// 将AuthController注册到GetX的依赖注入系统中
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 存储服务应该已经在main.dart中初始化并注册了
    // 这里只需要确保可以找到服务实例
    if (!Get.isRegistered<SharedPrefsStorageService>()) {
      throw Exception(
          'SharedPrefsStorageService not found. Make sure it is initialized in main.dart');
    }

    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true, // 允许控制器在需要时自动重新创建
    );
  }
}
