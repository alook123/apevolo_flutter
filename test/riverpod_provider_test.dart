import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('测试 Riverpod Provider 配置', (WidgetTester tester) async {
    // 设置测试环境
    SharedPreferences.setMockInitialValues({});

    // 初始化存储服务
    final storageService = SharedPrefsStorageService();
    await storageService.init();

    // 创建 ProviderScope 并覆盖存储服务
    final container = ProviderContainer(
      overrides: [
        sharedPrefsStorageServiceProvider.overrideWithValue(storageService),
      ],
    );

    // 验证可以成功获取存储服务
    final retrievedService = container.read(sharedPrefsStorageServiceProvider);
    expect(retrievedService, isNotNull);
    expect(retrievedService, equals(storageService));

    // 验证存储服务可以正常工作
    await retrievedService.setString('test', 'value');
    expect(retrievedService.getString('test'), equals('value'));

    container.dispose();
  });
}
