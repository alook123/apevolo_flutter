import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

/// 响应拦截器
/// 负责处理API响应数据的预处理，如JSON转换等
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 如果响应数据是字符串，尝试转换为JSON
    if (response.data is String) {
      try {
        response.data = json.decode(response.data);
      } catch (e) {
        Get.log("[ResponseInterceptor]: 响应数据JSON解析失败 - ${e.toString()}");
      }
    }
    handler.next(response);
  }
}
