import 'package:apevolo_flutter/app/data/models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/user/user_query_request_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:dio/dio.dart';

class UserProvider extends ApevoloDioService {
  final String prefix = '/api/user/';
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<UserQuery> query(UserQueryRequest requestData) async {
    final Response response = await dio.get(
      '${prefix}query',
      data: requestData,
    );

    UserQuery data = UserQuery.fromJson(response.data);
    return data;
  }
}
