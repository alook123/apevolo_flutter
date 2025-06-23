import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';
import 'package:apevolo_flutter/core/services/system_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final systemServiceProvider = Provider<SystemService>((ref) {
  final storage = ref.read(sharedPrefsStorageServiceProvider);
  return SystemService(storage);
});
