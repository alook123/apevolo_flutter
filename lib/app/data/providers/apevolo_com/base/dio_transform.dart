import 'package:dio/dio.dart';

/// Dio转换器
/// 负责处理请求和响应的数据转换
class DioTransform extends BackgroundTransformer {
  ///在PUT,POST和PATCH请求中才会回调
  @override
  Future<String> transformRequest(RequestOptions options) {
    return super.transformRequest(options);
  }

  ///除了PUT,POST和PATCH请求外，GET请求中也会回调
  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    ///转换返回的数据 为string: response
    // return Future.value('response');
    ///不转换数据
    return super.transformResponse(options, response);
  }
}
