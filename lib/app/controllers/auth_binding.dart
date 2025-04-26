import 'package:apevolo_flutter/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

/// 认证控制器绑定
///
/// 将AuthController注册到GetX的依赖注入系统中
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true, // 允许控制器在需要时自动重新创建
    );
  }
}
