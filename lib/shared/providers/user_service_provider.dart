import 'package:apevolo_flutter/shared/providers/hive_storage_service_provider.dart';
import 'package:apevolo_flutter/core/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final hiveStorage = ref.read(hiveStorageServiceProvider);
  return UserService(hiveStorage);
});
