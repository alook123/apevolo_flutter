import 'package:get/get.dart';

import '../components/captcha/bindings/captcha_binding.dart';
import '../components/captcha/views/captcha_view.dart';
import '../components/not_found/bindings/not_found_binding.dart';
import '../components/not_found/views/not_found_view.dart';
import '../components/search_filter/bindings/search_filter_binding.dart';
import '../components/search_filter/views/search_filter_view.dart';
import '../components/theme_mode/bindings/theme_mode_binding.dart';
import '../components/theme_mode/views/theme_mode_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/permission/user/bindings/user_binding.dart';
import '../modules/permission/user/views/user_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/shell/bindings/shell_binding.dart';
import '../modules/shell/views/shell_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static const NOT_FOUND = _Paths.COMPONENTS + _Paths.NOT_FOUND;

  static final routes = [
    GetPage(
      name: _Paths.SHELL,
      page: () => const ShellView(),
      binding: ShellBinding(),
      // middlewares: [
      //   RouteAuthMiddleware(priority: 1),
      // ],
      children: const [],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
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
    // GetPage(
    //   name: _Paths.PERMISSION,
    //   page: () => const permiss(),
    //   binding: ThemeModeBinding(),
    // ),
    GetPage(
      name: _Paths.PERMISSION + _Paths.USER,
      page: () => UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.COMPONENTS + _Paths.NOT_FOUND,
      page: () => const NotFoundView(),
      binding: NotFoundBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_FILTER,
      page: () => SearchFilterView(),
      binding: SearchFilterBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
  ];
}
