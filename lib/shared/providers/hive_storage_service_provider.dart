import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/hive_storage_service.dart';

final hiveStorageServiceProvider = Provider<HiveStorageService>((ref) {
  return HiveStorageService();
});
