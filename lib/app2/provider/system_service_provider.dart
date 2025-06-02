import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/hive_storage_service.dart';
import '../service/system_service.dart';
import 'hive_storage_service_provider.dart';

final systemServiceProvider = Provider<SystemService>((ref) {
  final hiveStorage = ref.read(hiveStorageServiceProvider);
  return SystemService(hiveStorage);
});
