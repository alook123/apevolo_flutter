import 'package:apevolo_flutter/app/service/system_service.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:apevolo_flutter/app/theme/dart_theme.dart';
import 'package:apevolo_flutter/app/theme/light_theme.dart';
import 'package:apevolo_flutter/app/utilities/logger_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
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
    ),
  );
}

Future<void> onInitialize() async {
  // await GetStorage.init();
  // await GetStorage.init('userData');
  Get.put(SystemService(), permanent: true);
  Get.put(UserService(), permanent: true);
}
