import 'package:apevolo_flutter/app/data/models/apevolo_models/auth/auth_login.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_rest_client.g.dart';

@RestApi(baseUrl: '/auth/')
abstract class AuthRestClient {
  factory AuthRestClient(Dio dio, {String baseUrl}) = _AuthRestClient;

  @POST('/login')
  Future<AuthLogin> login(
    @Field() String userName,
    @Field() String password,
    @Field() String captcha,
    @Field() String? captchaId,
  );

  @GET('/info')
  Future<HttpResponse<dynamic>> info();

  @GET('/captcha')
  Future<dynamic> captcha();

  @POST('/auth/reset/email')
  Future<HttpResponse<dynamic>> resetEmail(@Query('email') String email);

  @DELETE('/logout')
  Future<HttpResponse<dynamic>> logout();
}
