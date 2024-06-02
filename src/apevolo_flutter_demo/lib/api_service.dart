import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'user.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/users")
  Future<List<User>> getUsers();
}
