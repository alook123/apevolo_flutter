import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/permission/user/bindings/user_binding.dart';
import '../modules/permission/user/views/user_view.dart';
import '../modules/widget/captcha/bindings/captcha_binding.dart';
import '../modules/widget/captcha/views/captcha_view.dart';
import '../modules/widget/theme_mode/bindings/theme_mode_binding.dart';
import '../modules/widget/theme_mode/views/theme_mode_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      // middlewares: [
      //   RouteAuthMiddleware(priority: 1),
      // ],
      children: [],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CAPTCHA,
      page: () => const CaptchaView(),
      binding: CaptchaBinding(),
    ),
    GetPage(
      name: _Paths.THEME_MODE,
      page: () => const ThemeModeView(),
      binding: ThemeModeBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
  ];
}
