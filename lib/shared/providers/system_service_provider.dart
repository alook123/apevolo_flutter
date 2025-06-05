import 'package:apevolo_flutter/core/services/hive_storage_service.dart';
import 'package:apevolo_flutter/core/services/system_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final systemServiceProvider = Provider<SystemService>((ref) {
  final hiveStorage = ref.read(hiveStorageServiceProvider);
  return SystemService(hiveStorage);
});
