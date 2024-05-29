import 'package:apevolo_flutter/app/data/models/auth/auth_login_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart';

class AuthorizationProvider extends ApevoloDioService {
  final String prefix = '/auth/';

  Future<AuthLogin> login(
    String username,
    String password,
    String captcha,
    String captchaId,
  ) async {
    final publicPem =
        await rootBundle.loadString('assets/certificate/public_apevolo.pem');
    dynamic publicKey = RSAKeyParser().parse(publicPem);
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    String passwordBase64 = encrypter.encrypt(password).base64;

    final Response response = await dio.post(
      '${prefix}login',
      data: {
        'username': username,
        'password': passwordBase64,
        'captcha': captcha,
        'captchaId': captchaId,
      },
    );
    AuthLogin data = AuthLogin.fromJson(response.data);
    return data;
  }

  Future<Response> info() => dio.get('${prefix}info');

  Future<Map<String, dynamic>> captcha() async {
    final response = await dio.get(
      '${prefix}captcha',
    );
    return response.data;
  }

  Future<Response> logout() => dio.delete('${prefix}logout');

  Future<Response> resetEmail(String email) => dio.post(
        '${prefix}auth/reset/email',
        queryParameters: {email: email},
      );
}
