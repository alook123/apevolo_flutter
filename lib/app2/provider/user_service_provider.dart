import 'package:apevolo_flutter/app2/provider/hive_storage_service_provider.dart';
import 'package:apevolo_flutter/app2/service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final hiveStorage = ref.read(hiveStorageServiceProvider);
  return UserService(hiveStorage);
});
