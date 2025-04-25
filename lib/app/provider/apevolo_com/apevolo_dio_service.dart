import 'dart:convert';

import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/routes/app_pages.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class ApevoloDioService extends GetxService {
  final UserService userService = Get.find<UserService>();
  late final Dio dio;

  ApevoloDioService() {
    final baseOptions = BaseOptions(
      baseUrl: "http://apevolo.api.alook.life",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'IsWasm': kIsWasm ? 'true' : 'false',
        'Accept': 'application/json',
      },
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    // 在非Web平台上添加sendTimeout设置
    if (!kIsWeb) {
      baseOptions.sendTimeout = const Duration(seconds: 60);
    }

    dio = Dio(baseOptions);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    //拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: requestInterceptor,
        onResponse: responseInterceptor,
        onError: errorInterceptor,
      ),
    );
    //dio.interceptors.add(QueuedInterceptor());
    // dio.interceptors.add(BackgroundTransformer());
  }

  void requestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (userService.loginInfo.value?.token.accessToken != null) {
      options.headers['Authorization'] =
          'Bearer ${userService.loginInfo.value?.token.accessToken}';
    }

    // 在Web平台上，对于没有请求体的请求，移除sendTimeout设置
    if (kIsWeb && options.data == null) {
      options.sendTimeout = null;
    }

    return handler.next(options);
  }

  void responseInterceptor(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.data is String) {
      try {
        response.data = json.decode(response.data);
      } catch (e) {
        Get.log("[ApevoloDio]:响应之后:response.data is String:转换失败");
      }
    }
    return handler.next(response);
  }

  void errorInterceptor(
    DioException exception,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint("[ApevoloDio]:错误之后");

    /// 是否是定时任务
    bool isScheduledTask =
        exception.requestOptions.extra['isScheduledTask'] ?? false;
    if (isScheduledTask) {
      handler.next(exception);
      return;
    }

    // 处理网络错误，如XMLHttpRequest onError回调触发等情况
    if (exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.unknown) {
      Get.snackbar(
        '网络错误',
        '连接服务器失败，请检查网络连接后重试',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return handler.next(exception);
    }

    if (exception.response?.statusCode == 401) {
      if (userService.loginInfo.value?.token.accessToken != null) {
        // 如果收到 401 响应，则刷新访问令牌}
        Token token =
            await refreshToken(userService.loginInfo.value!.token.accessToken!);

        //使用新的访问令牌更新请求标头
        exception.requestOptions.headers['Authorization'] =
            'Bearer ${token.accessToken}';
        final old = userService.loginInfo.value!;
        userService.loginInfo.value = old.copyWith(token: token);
        // userService.loginInfo.value?.token = token;
        userService.loginInfo.refresh();

        //使用更新后的标头重复请求
        return handler.resolve(await dio.fetch(exception.requestOptions));
      } else {
        Get.offAllNamed(Routes.LOGIN);
        return handler.next(exception);
      }
    }
    if (exception.response?.statusCode == 403) {
      // 如果提示过该提示，则不再提示
      if (userService.loginInfo.value?.token.accessToken == null) {
        return handler.next(exception);
      }

      Get.snackbar(
        '提示',
        '''您没有权限访问此资源，请联系管理员。''',
        snackPosition: SnackPosition.BOTTOM,
      );
      userService.clearUserInfo();

      /// 如果当前页面是登录页，则不需要跳转
      if (Get.currentRoute != Routes.LOGIN) {
        Get.offAndToNamed(Routes.LOGIN);
      }
    }

    int statusCode = exception.response?.statusCode ?? 0;

    if (statusCode == 400) {
      if (exception.response?.realUri.path == '/auth/refreshToken') {
        Get.offAllNamed(Routes.LOGIN);
        return handler.next(exception);
      }
    }

    if (statusCode == 429) {
      Get.snackbar(
        '提示',
        exception.response?.data['message'],
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    handler.reject(exception);
  }

  Future<Token> refreshToken(String token) async {
    final Response response = await dio.post(
      '${dio.options.baseUrl}/auth/refreshToken',
      queryParameters: {'token': token},
    );
    response.data['access_token'] = response.data['refresh_token'];
    Token data = Token.fromJson(response.data);
    return data;
  }
}
