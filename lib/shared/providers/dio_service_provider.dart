import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apevolo_flutter/network/apevolo_com/base/dio_service.dart';

final dioServiceProvider = Provider<DioService>((ref) {
  return DioService();
});
