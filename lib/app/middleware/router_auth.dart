import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteAuthMiddleware extends GetMiddleware {
  RouteAuthMiddleware({required super.priority});

  @override
  RouteSettings? redirect(String? route) {
    final UserService userService = Get.find<UserService>();
    if (userService.loginInfo.value?.user != null) {
      return null;
    }
    Future.delayed(
      const Duration(milliseconds: 200),
      () => Get.rawSnackbar(title: "提示", message: "请先登录APP"),
    );
    return const RouteSettings(name: Routes.LOGIN);
  }
}
