import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/api_client.dart';
import 'package:apevolo_flutter/app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

/// ApevoloDioService类 - 兼容层
///
/// 此类现在作为一个兼容层，将调用重定向到新的结构化组件。
/// 新代码应该直接使用ApiClient和相关服务。
class ApevoloDioService extends GetxService {
  final UserService userService = Get.find<UserService>();
  late final Dio dio;
  late final ApiClient apiClient;

  ApevoloDioService() {
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

  /// 刷新访问令牌 - 兼容方法
  ///
  /// 此方法现在只是重定向到TokenService
  ///
  /// [token] 当前的访问令牌
  /// 返回新的令牌信息
  Future<Token> refreshToken(String token) async {
    return await apiClient.tokenService.refreshToken(token);
  }
}
