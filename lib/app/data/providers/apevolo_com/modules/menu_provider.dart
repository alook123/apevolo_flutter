import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/create_update_menu_dto.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_model.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/common/action_result_vm.dart';
import 'package:apevolo_flutter/app/data/models/apevolo_models/common/id_collection.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'menu_provider.g.dart';

/// 菜单相关API提供者
@RestApi(baseUrl: '/api/menu')
abstract class MenuProvider {
  /// 创建MenuProvider实例
  factory MenuProvider(Dio dio, {String baseUrl}) = _MenuProvider;

  /// 新增菜单
  ///
  /// [menu] 菜单信息
  @POST('/create')
  Future<ActionResultVm> create(@Body() CreateUpdateMenuDto menu);

  /// 更新菜单
  ///
  /// [menu] 菜单信息
  @PUT('/edit')
  Future<void> edit(@Body() CreateUpdateMenuDto menu);

  /// 删除菜单
  ///
  /// [ids] 菜单ID集合
  @DELETE('/delete')
  Future<ActionResultVm> delete(@Body() IdCollection ids);

  /// 构建树形菜单
  ///
  /// 返回用户可访问的菜单树形结构
  @GET('/build')
  Future<List<MenuBuild>> build();

  /// 获取子菜单
  ///
  /// [pid] 父菜单ID
  @GET('/lazy')
  Future<List<MenuVo>> lazy(@Query('pid') int pid);

  /// 获取菜单列表
  ///
  /// [title] 菜单标题
  /// [parentId] 父级ID
  /// [createTime] 创建时间：开始[0]--结束[1]
  @GET('/query')
  Future<ActionResultVm<List<MenuVo>>> query({
    @Query('Title') String? title,
    @Query('ParentId') int? parentId,
    @Query('CreateTime') List<DateTime>? createTime,
  });

  /// 导出菜单
  ///
  /// [title] 菜单标题
  /// [parentId] 父级ID
  /// [createTime] 创建时间：开始[0]--结束[1]
  @GET('/download')
  Future<ActionResultVm<List<MenuVo>>> download({
    @Query('Title') String? title,
    @Query('ParentId') int? parentId,
    @Query('CreateTime') List<DateTime>? createTime,
  });

  /// 获取同级与上级菜单
  ///
  /// [ids] 菜单ID集合
  @GET('/superior')
  Future<List<MenuVo>> getSuperiors(@Query('ids') List<int> ids);

  /// 获取子菜单
  ///
  /// [id] 菜单ID
  @GET('/child')
  Future<List<MenuVo>> getChildMenus(@Query('id') int id);
}
