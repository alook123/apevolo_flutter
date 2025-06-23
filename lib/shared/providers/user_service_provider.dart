import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:apevolo_flutter/core/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final storage = ref.read(sharedPrefsStorageServiceProvider);
  return UserService(storage);
});
