import 'package:apevolo_flutter/app/controllers/auth_binding.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/dio_service.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:apevolo_flutter/app/theme/dart_theme.dart';
import 'package:apevolo_flutter/app/theme/light_theme.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  // 初始化SharedPreferences存储服务
  final storageService = SharedPrefsStorageService();
  await storageService.init();

  // 把存储服务注册到Get依赖注入系统中
  Get.put(storageService, permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      enableLog: true,
      onInit: onInitialize,
      initialBinding: AuthBinding(), // 添加AuthBinding作为初始绑定
      logWriterCallback: Logger.write,
      theme: lightTheme,
      darkTheme: darkTheme,
      supportedLocales: const [
        Locale('zh', 'CN'), // 添加中文支持
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      //scrollBehavior: MyCustomScrollBehavior(),
    ),
  );
}

Future<void> onInitialize() async {
  // 获取已注册的存储服务
  final storageService = Get.find<SharedPrefsStorageService>();

  // 初始化系统和用户服务
  Get.put(SystemService(storageService), permanent: true);
  Get.put(UserService(storageService), permanent: true);
  Get.put(DioService(), permanent: true);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
