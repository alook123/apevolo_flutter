import 'package:hive/hive.dart';
import 'package:apevolo_flutter/app/service/storage/adapters/auth_adapters.dart';
import 'package:apevolo_flutter/app/service/storage/adapters/menu_adapters.dart';

/// Hive适配器注册器
///
/// 集中管理和注册所有Hive类型适配器
class HiveRegistry {
  /// 注册所有适配器
  ///
  /// 此方法应在应用程序启动时调用，以确保所有需要的适配器都已注册
  static void registerAdapters() {
    // 认证适配器
    Hive.registerAdapter(AuthLoginAdapter());

    // 菜单适配器
    Hive.registerAdapter(MenuBuildAdapter());
    Hive.registerAdapter(ChildrenMenuAdapter());
  }
}
