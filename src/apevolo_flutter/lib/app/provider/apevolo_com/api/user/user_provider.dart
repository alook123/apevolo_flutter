import 'package:apevolo_flutter/app/data/models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/user/user_query_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_provider.g.dart';

@RestApi(baseUrl: '/api/user')
abstract class UserProvider {
  factory UserProvider(Dio dio, {String baseUrl}) = _UserProvider;

  @GET('/query')
  Future<UserQuery> query(@Body() UserQueryRequest task);
}
