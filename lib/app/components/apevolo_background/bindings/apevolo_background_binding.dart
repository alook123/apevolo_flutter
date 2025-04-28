import 'package:get/get.dart';
import '../controllers/apevolo_background_controller.dart';

/// ApeVolo背景组件的绑定类
class ApeVoloBackgroundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApeVoloBackgroundController>(
      () => ApeVoloBackgroundController(),
      fenix: true, // 设置为true以允许控制器在需要时被重新创建
    );
  }
}
