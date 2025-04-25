import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_provider.g.dart';

@RestApi(baseUrl: '/api/user')
abstract class UserProvider {
  factory UserProvider(Dio dio, {String baseUrl}) = _UserProvider;

  @GET('/query')
  Future<UserQuery> query(
    @Query('id') int? id,
    @Query('deptId') int? deptId,
    @Query('deptIds') List<int>? deptIds,
    @Query('keyWords') String? keyWords,
    @Query('enabled') bool? enabled,
    @Query('pageIndex') int? pageIndex,
    @Query('pageSize') int? pageSize,
    @Query('sortFields') List<String>? sortFields,
    @Query('totalElements') int? totalElements,
  );
}
