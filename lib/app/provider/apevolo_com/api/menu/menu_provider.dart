import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'menu_provider.g.dart';

@RestApi(baseUrl: '/api/menu')
abstract class MenuProvider {
  factory MenuProvider(Dio dio, {String baseUrl}) = _MenuProvider;

  @GET('/build')
  Future<List<MenuBuild>> build();
}
