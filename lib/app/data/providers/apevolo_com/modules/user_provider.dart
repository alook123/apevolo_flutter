import 'package:apevolo_flutter/app/data/models/apevolo_models/common/action_result_vm.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/common/id_collection.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/user/create_update_user_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_query_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/user/user_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:io';

part 'user_provider.g.dart';

@RestApi(baseUrl: '/api/user')
abstract class UserProvider {
  factory UserProvider(Dio dio, {String baseUrl}) = _UserProvider;

  /// 创建用户
  @POST('/create')
  Future<ActionResultVm<UserResponseModel>> create(
    @Body() CreateUpdateUserModel user,
  );

  /// 更新用户
  @PUT('/edit')
  Future<void> edit(
    @Body() CreateUpdateUserModel user,
  );

  /// 删除用户
  @DELETE('/delete')
  Future<ActionResultVm<UserResponseModel>> delete(
    @Body() IdCollection ids,
  );

  /// 更新用户个人中心信息
  @PUT('/update/center')
  Future<void> updateCenter(
    @Body() UpdateUserCenterModel userCenter,
  );

  /// 更新用户密码
  @POST('/update/password')
  Future<ActionResultVm<UserResponseModel>> updatePassword(
    @Body() UpdatePasswordModel passwordInfo,
  );

  /// 更新用户邮箱
  @POST('/update/email')
  Future<ActionResultVm<UserResponseModel>> updateEmail(
    @Body() UpdateEmailModel emailInfo,
  );

  /// 更新用户头像
  @POST('/update/avatar')
  @MultiPart()
  Future<ActionResultVm<UserResponseModel>> updateAvatar(
    @Part() File avatar,
  );

  /// 查询用户列表
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

  /// 导出用户列表
  @GET('/download')
  Future<List<int>> download(
    @Query('id') int? id,
    @Query('keyWords') String? keyWords,
    @Query('enabled') bool? enabled,
    @Query('deptId') int? deptId,
    @Query('deptIdItems') String? deptIdItems,
    @Query('createTime') List<DateTime>? createTime,
  );
}
