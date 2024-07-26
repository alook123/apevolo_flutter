import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:apevolo_flutter/app/theme/dart_theme.dart';
import 'package:apevolo_flutter/app/theme/light_theme.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  await GetStorage.init();
  await GetStorage.init('userData');
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      enableLog: true,
      onInit: onInitialize,
      logWriterCallback: Logger.write,
      theme: lightTheme,
      darkTheme: darkTheme,
      supportedLocales: const [
        Locale('zh', 'CN'), // 添加中文支持
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // scrollBehavior: MyCustomScrollBehavior(),
    ),
  );
}

Future<void> onInitialize() async {
  Get.put(SystemService(), permanent: true);
  Get.put(UserService(), permanent: true);
  Get.put(ApevoloDioService(), permanent: true);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
