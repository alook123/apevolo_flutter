import 'package:apevolo_flutter/shared/network/apevolo_com/modules/auth_rest_client.dart';
import 'package:apevolo_flutter/shared/providers/dio_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRestClientProvider = Provider<AuthRestClient>((ref) {
  final dio = ref.read(dioServiceProvider).dio;
  return AuthRestClient(dio);
});
