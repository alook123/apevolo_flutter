import 'package:apevolo_flutter/app/data/rest_clients/apevolo_com/modules/auth_rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dio_service_provider.dart';

final authRestClientProvider = Provider<AuthRestClient>((ref) {
  final dio = ref.read(dioServiceProvider).dio;
  return AuthRestClient(dio);
});
