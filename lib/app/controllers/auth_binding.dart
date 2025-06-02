import 'package:apevolo_flutter/app/controllers/auth_controller.dart';
import 'package:apevolo_flutter/app/service/storage/hive_storage_service.dart';
import 'package:get/get.dart';

/// 认证控制器绑定
///
/// 将AuthController注册到GetX的依赖注入系统中
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 确保存储服务已注册
    if (!Get.isRegistered<HiveStorageService>()) {
      final storageService = HiveStorageService();
      // 在主线程之外异步初始化存储服务
      storageService.init().then((_) {
        // 初始化完成后注册服务
        Get.put(storageService, permanent: true);
      });
    }

    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true, // 允许控制器在需要时自动重新创建
    );
  }
}
