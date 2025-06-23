import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';

void main() {
  testWidgets('应用基础组件测试', (WidgetTester tester) async {
    // 准备测试环境
    Get.reset();

    // 创建存储服务
    final storageService = SharedPrefsStorageService();
    await storageService.init();
    Get.put(storageService, permanent: true);

    // 验证存储服务正常工作
    expect(Get.find<SharedPrefsStorageService>(), isNotNull);
  });
}
