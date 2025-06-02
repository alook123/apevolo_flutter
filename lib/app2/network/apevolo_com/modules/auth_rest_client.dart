import 'package:apevolo_flutter/app2/network/apevolo_com/models/auth/auth_login.dart';
import 'package:apevolo_flutter/app2/network/apevolo_com/models/auth/captcha_response.dart';
import 'package:apevolo_flutter/app2/network/apevolo_com/models/auth/token.dart';
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
  Future<CaptchaResponse> captcha();

  @POST('/auth/reset/email')
  Future<HttpResponse<dynamic>> resetEmail(@Query('email') String email);

  @DELETE('/logout')
  Future<HttpResponse<dynamic>> logout();

  @POST('/auth/refreshToken')
  Future<Token> refreshToken(
    @Query('token') String token,
  );
}
