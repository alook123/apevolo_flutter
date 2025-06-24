import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

/// API错误处理器
/// 负责处理API请求过程中的错误并显示用户友好的错误消息
class ApiErrorHandler {
  /// 显示错误消息的统一方法
  ///
  /// 封装错误提示的显示逻辑，统一错误信息展示风格
  ///
  /// [title] 错误提示标题
  /// [message] 错误提示详细信息
  /// [duration] 提示显示的持续时间，默认3秒
  /// [isError] 是否为错误类型提示，影响提示的样式和颜色，默认为true
  void showErrorMessage({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = true,
  }) {
    debugPrint("[ApiErrorHandler]: $title - $message");
    // Get.log("[ApiErrorHandler]: $title - $message");
    // Get.snackbar(
    //   title,
    //   message,
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: duration,
    //   backgroundColor: isError
    //       ? Get.theme.colorScheme.errorContainer.withOpacity(0.8)
    //       : null,
    //   colorText: isError ? Get.theme.colorScheme.onErrorContainer : null,
    // );
  }

  /// 从响应中提取错误信息
  ///
  /// 从DioException中智能提取错误信息，按优先级依次从response.data['message']、
  /// response.data['error']、exception.message中获取，若都不存在则返回默认错误信息
  ///
  /// [exception] Dio请求异常对象
  /// 返回提取的错误信息字符串
  String extractErrorMessage(DioException exception) {
    if (exception.response?.data != null) {
      if (exception.response!.data is Map) {
        return exception.response!.data['message'] ??
            exception.response!.data['error'] ??
            exception.message ??
            '未知错误';
      }
    }
    return exception.message ?? '请求处理过程中发生错误';
  }

  /// 根据HTTP状态码和异常信息显示适当的错误消息
  ///
  /// [statusCode] HTTP状态码
  /// [exception] Dio异常对象
  /// [path] 请求路径，用于特殊路径的错误处理逻辑
  void handleErrorByStatusCode(int statusCode, DioException exception,
      {String? path}) {
    switch (statusCode) {
      case 400:
        if (path == '/auth/refreshToken') {
          showErrorMessage(
            title: '会话过期',
            message: '您的会话已经过期，请重新登录',
          );
        } else {
          showErrorMessage(
            title: '请求错误',
            message: extractErrorMessage(exception),
          );
        }
        break;
      case 429:
        showErrorMessage(
          title: '请求过于频繁',
          message: extractErrorMessage(exception),
        );
        break;
      default:
        if (statusCode >= 500) {
          showErrorMessage(
            title: '服务器错误',
            message: '服务器处理请求时出现错误，请稍后再试',
          );
        } else {
          showErrorMessage(
            title: '请求失败',
            message: extractErrorMessage(exception),
          );
        }
    }
  }
}
