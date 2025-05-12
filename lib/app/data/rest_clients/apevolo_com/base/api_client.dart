import 'package:apevolo_flutter/app/constants/apevolo_constants.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/error_handler.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/interceptors/auth_interceptor.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/interceptors/response_interceptor.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/services/token_service.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// API客户端
/// 负责创建和配置Dio实例，集成各种拦截器和服务
class ApiClient extends GetxService {
  late final Dio dio;
  late final ApiErrorHandler errorHandler;
  late final TokenService tokenService;
  late final AuthInterceptor authInterceptor;
  late final ResponseInterceptor responseInterceptor;
  final UserService userService = Get.find<UserService>();

  ApiClient() {
    _initDio();
    _initServices();
    _initInterceptors();
  }

  /// 初始化Dio实例
  void _initDio() {
    final baseOptions = BaseOptions(
      baseUrl: ApevoloConstants.baseURL,
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

  /// 初始化服务
  void _initServices() {
    errorHandler = ApiErrorHandler();
    tokenService = TokenService(dio);
  }

  /// 初始化拦截器
  void _initInterceptors() {
    // 添加日志拦截器
    dio.interceptors.add(LogInterceptor(responseBody: true));

    // 添加响应拦截器 - 用于JSON处理
    responseInterceptor = ResponseInterceptor();
    dio.interceptors.add(responseInterceptor);

    // 添加认证拦截器 - 处理认证和错误
    authInterceptor = AuthInterceptor(
      userService: userService,
      tokenService: tokenService,
      errorHandler: errorHandler,
      dio: dio,
    );
    dio.interceptors.add(authInterceptor);

    // 可选: 添加后台转换器，用于大型JSON响应的处理
    // dio.interceptors.add(BackgroundTransformer());
  }

  /// 获取Dio实例
  Dio getDio() {
    return dio;
  }
}
