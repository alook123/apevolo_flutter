/// TokenService Provider
/// 为 TokenService 提供 Riverpod 依赖注入支持
library token_service_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:apevolo_flutter/core/services/token_service.dart';

part 'token_service_provider.g.dart';

/// TokenService Provider
/// 提供 TokenService 实例，用于 token 的存储、读取和清除
@riverpod
TokenService tokenService(Ref ref) {
  return TokenService();
}
