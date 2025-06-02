import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/token.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/api_client.dart';
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
    return await apiClient.tokenService.refreshToken(token);
  }
}
