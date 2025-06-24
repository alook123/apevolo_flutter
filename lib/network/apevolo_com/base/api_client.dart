import 'package:apevolo_flutter/core/constants/apevolo_constants.dart';
import 'package:apevolo_flutter/network/apevolo_com/base/error_handler.dart';
import 'package:apevolo_flutter/network/apevolo_com/base/interceptors/auth_interceptor.dart';
import 'package:apevolo_flutter/network/apevolo_com/base/interceptors/response_interceptor.dart';
import 'package:apevolo_flutter/core/services/token_service.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// API客户端
/// 负责创建和配置Dio实例，集成各种拦截器和服务
class ApiClient {
  late final Dio dio;
  late final ApiErrorHandler errorHandler;
  late final TokenService tokenService;
  late final AuthInterceptor authInterceptor;
  late final ResponseInterceptor responseInterceptor;
  late final SharedPrefsStorageService storageService;

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
    tokenService = TokenService();
    storageService = SharedPrefsStorageService();
  }

  /// 初始化拦截器
  void _initInterceptors() {
    dio.interceptors.add(LogInterceptor(requestBody: true)); // 打印请求体
    dio.interceptors.add(LogInterceptor(requestHeader: true)); // 打印请求头
    dio.interceptors.add(LogInterceptor(responseHeader: true)); // 打印响应头
    dio.interceptors.add(LogInterceptor(responseBody: true)); // 打印响应体

    responseInterceptor = ResponseInterceptor();
    dio.interceptors.add(responseInterceptor);

    authInterceptor = AuthInterceptor(
      getToken: _getTokenFromStorage,
      tokenService: tokenService,
      errorHandler: errorHandler,
      dio: dio,
    );
    dio.interceptors.add(authInterceptor);

    // 可选: 添加后台转换器，用于大型JSON响应的处理
    // dio.interceptors.add(BackgroundTransformer());
  }

  /// 从存储中获取访问令牌
  /// 使用 SharedPrefsStorageService 读取登录信息并提取token
  Future<String?> _getTokenFromStorage() async {
    try {
      if (kDebugMode) {
        print('ApiClient: 开始获取token...');
      }

      if (kIsWeb) {
        // Web平台使用sessionStorage
        final token = web.window.sessionStorage.getItem('access_token');
        if (kDebugMode) {
          print('ApiClient: Web平台获取token: ${token?.substring(0, 20)}...');
        }
        return token;
      } else {
        // 其他平台使用SharedPreferences通过TokenService
        final accessToken = await tokenService.getAccessToken();
        if (kDebugMode) {
          print(
              'ApiClient: 从SharedPreferences获取到accessToken: ${accessToken?.substring(0, 20)}...');
        }
        return accessToken;
      }
    } catch (e) {
      if (kDebugMode) {
        print('ApiClient: 获取token失败: $e');
      }
    }

    if (kDebugMode) {
      print('ApiClient: 没有找到token，返回null');
    }
    return null;
  }

  /// 获取Dio实例
  Dio getDio() {
    return dio;
  }
}
