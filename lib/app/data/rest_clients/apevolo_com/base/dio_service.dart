import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/token.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/base/api_client.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

/// DioService 类 - 基础Dio服务
///
/// 提供Dio实例和基础网络功能
class DioService extends GetxService {
  final UserService userService = Get.find<UserService>();
  late final Dio dio;
  late final ApiClient apiClient;

  DioService() {
    // 创建API客户端实例
    apiClient = ApiClient();
    // 获取Dio实例
    dio = apiClient.dio;
  }

  @override
  void onInit() {
    super.onInit();
    // 所有初始化工作现在在ApiClient中完成
  }

  /// 刷新访问令牌
  ///
  /// [token] 当前的访问令牌
  /// 返回新的令牌信息
  Future<Token> refreshToken(String token) async {
    return await apiClient.tokenService.refreshToken(token);
  }
}
