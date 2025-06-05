import 'package:apevolo_flutter/shared/network/apevolo_com/base/error_handler.dart';
import 'package:apevolo_flutter/core/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 认证拦截器
/// 负责处理请求的认证流程，包括添加令牌和处理令牌刷新
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final TokenService tokenService;
  final ApiErrorHandler errorHandler;
  final Dio dio;

  AuthInterceptor({
    required this.getToken,
    required this.tokenService,
    required this.errorHandler,
    required this.dio,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // 在Web平台上，对于没有请求体的请求，移除sendTimeout设置
    if (kIsWeb && options.data == null) {
      options.sendTimeout = null;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 检查是否为定时任务，如果是则不处理错误
    bool isScheduledTask = err.requestOptions.extra['isScheduledTask'] ?? false;
    if (isScheduledTask) {
      return handler.next(err);
    }

    // 处理网络错误
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.unknown) {
      errorHandler.showErrorMessage(
        title: '网络错误',
        message: '连接服务器失败，请检查网络连接后重试',
      );
      return handler.next(err);
    }

    // 处理401未授权错误
    if (err.response?.statusCode == 401) {
      await _handle401Error(err, handler);
      return;
    }

    // 处理403权限不足错误
    if (err.response?.statusCode == 403) {
      await _handle403Error(err, handler);
      return;
    }

    // 处理其他错误
    _handleOtherErrors(err, handler);
  }

  /// 处理401未授权错误
  Future<void> _handle401Error(
      DioException err, ErrorInterceptorHandler handler) async {
    errorHandler.showErrorMessage(
      title: '认证失败',
      message: '您的登录信息已过期，请重新登录',
    );
    return handler.next(err);
  }

  /// 处理403权限不足错误
  Future<void> _handle403Error(
      DioException err, ErrorInterceptorHandler handler) async {
    errorHandler.showErrorMessage(
      title: '权限不足',
      message: '您没有权限访问此资源，请联系管理员',
    );
    return handler.next(err);
  }

  /// 处理其他HTTP错误
  void _handleOtherErrors(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode ?? 0;

    if (statusCode > 0) {
      final path = err.response?.realUri.path;

      if (statusCode == 400) {
        if (path == '/auth/refreshToken') {
          errorHandler.showErrorMessage(
            title: '会话过期',
            message: '您的会话已经过期，请重新登录',
          );
          // Get.offAllNamed(Routes.LOGIN);
        } else {
          errorHandler.showErrorMessage(
            title: '请求错误',
            message: errorHandler.extractErrorMessage(err),
          );
        }
      } else if (statusCode == 429) {
        errorHandler.showErrorMessage(
          title: '请求过于频繁',
          message: errorHandler.extractErrorMessage(err),
        );
      } else if (statusCode >= 500) {
        errorHandler.showErrorMessage(
          title: '服务器错误',
          message: '服务器处理请求时出现错误，请稍后再试',
        );
      } else {
        errorHandler.showErrorMessage(
          title: '请求失败',
          message: errorHandler.extractErrorMessage(err),
        );
      }
    }

    return handler.next(err);
  }
}
