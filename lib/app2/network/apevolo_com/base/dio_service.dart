import 'package:apevolo_flutter/app2/network/apevolo_com/base/api_client.dart';
import 'package:apevolo_flutter/app2/network/apevolo_com/models/auth/token.dart'
    show Token;
import 'package:apevolo_flutter/app2/network/apevolo_com/modules/auth_rest_client.dart';
import 'package:dio/dio.dart';

/// DioService 类 - 基础Dio服务
///
/// 提供Dio实例和基础网络功能
class DioService {
  late final Dio dio;
  late final ApiClient apiClient;

  DioService() {
    // 创建API客户端实例
    apiClient = ApiClient();
    // 获取Dio实例
    dio = apiClient.dio;
  }

  /// 刷新访问令牌
  ///
  /// [token] 当前的访问令牌
  /// 返回新的令牌信息
  Future<Token> refreshToken(String token) async {
    try {
      return await AuthRestClient(dio).refreshToken(token);
    } catch (error) {
      // 处理错误
      throw Exception('Failed to refresh token: $error');
    }
  }
}
