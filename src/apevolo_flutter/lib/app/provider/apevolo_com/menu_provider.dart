import 'package:apevolo_flutter/app/data/models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/provider/apevolo_com/apevolo_dio_service.dart';
import 'package:dio/dio.dart';

class MenuProvider extends ApevoloDioService {
  final String prefix = '/api/menu/';

  Future<List<MenuBuild>> build() async {
    final Response response = await dio.get('${prefix}build');
    List<MenuBuild> data =
        response.data.map<MenuBuild>((e) => MenuBuild.fromJson(e)).toList();
    return data;
  }
}
