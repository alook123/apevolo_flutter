import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_update_menu_dto.g.dart';
part 'create_update_menu_dto.freezed.dart';

/// 创建或更新菜单的数据传输对象
@freezed
abstract class CreateUpdateMenuDto with _$CreateUpdateMenuDto {
  const factory CreateUpdateMenuDto({
    /// 菜单ID (更新时需要)
    int? id,

    /// 菜单类型(0:目录 1:菜单 2:按钮)
    int? type,

    /// 权限标识
    String? permission,

    /// 菜单标题
    required String title,

    /// 组件名称
    String? name,

    /// 组件路径
    String? component,

    /// 排序
    int? sort,

    /// 图标
    String? icon,

    /// 路径
    String? path,

    /// 是否外链
    bool? iFrame,

    /// 缓存
    bool? cache,

    /// 隐藏
    bool? hidden,

    /// 父级菜单ID
    int? pid,
  }) = _CreateUpdateMenuDto;

  factory CreateUpdateMenuDto.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateMenuDtoFromJson(json);
}
