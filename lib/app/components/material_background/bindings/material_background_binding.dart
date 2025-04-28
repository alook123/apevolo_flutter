import 'package:get/get.dart';
import '../controllers/material_background_controller.dart';

class MaterialBackgroundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialBackgroundController>(
      () => MaterialBackgroundController(),
    );
  }
}
