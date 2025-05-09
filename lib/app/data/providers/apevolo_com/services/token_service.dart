import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/token.dart';
import 'package:dio/dio.dart';

/// 令牌服务
/// 负责处理与令牌相关的操作，如刷新令牌
class TokenService {
  final Dio dio;

  TokenService(this.dio);

  /// 刷新访问令牌
  ///
  /// 向服务器发送请求获取新的令牌，并处理兼容性问题
  ///
  /// [token] 当前的访问令牌，用于请求新的令牌
  /// 返回包含新令牌信息的Token对象
  Future<Token> refreshToken(String token) async {
    final Response response = await dio.post(
      '${dio.options.baseUrl}/auth/refreshToken',
      queryParameters: {'token': token},
    );

    // 处理API兼容性问题
    // 如果API没有正确返回access_token，这里做一个兼容处理
    if (response.data['access_token'] == null &&
        response.data['refresh_token'] != null) {
      response.data['access_token'] = response.data['refresh_token'];
    }

    return Token.fromJson(response.data);
  }
}
