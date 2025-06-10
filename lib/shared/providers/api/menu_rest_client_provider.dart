import 'package:apevolo_flutter/shared/network/apevolo_com/modules/api/menu_rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dio_service_provider.dart';

final menuRestClientProvider = Provider<MenuRestClient>((ref) {
  final dio = ref.read(dioServiceProvider).dio;
  return MenuRestClient(dio);
});
