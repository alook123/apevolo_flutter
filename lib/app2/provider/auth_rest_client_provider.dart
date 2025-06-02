import 'package:dio/dio.dart';
import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/modules/auth_rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(); // 可根据需要配置拦截器、baseUrl等
});

final authRestClientProvider = Provider<AuthRestClient>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRestClient(dio);
});
