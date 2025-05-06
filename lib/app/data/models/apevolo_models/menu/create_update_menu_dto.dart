import 'package:json_annotation/json_annotation.dart';

part 'create_update_menu_dto.g.dart';

/// 创建或更新菜单的数据传输对象
@JsonSerializable()
class CreateUpdateMenuDto {
  /// 菜单ID (更新时需要)
  final int? id;

  /// 菜单类型(0:目录 1:菜单 2:按钮)
  final int? type;

  /// 权限标识
  final String? permission;

  /// 菜单标题
  final String title;

  /// 组件名称
  final String? name;

  /// 组件路径
  final String? component;

  /// 排序
  final int? sort;

  /// 图标
  final String? icon;

  /// 路径
  final String? path;

  /// 是否外链
  final bool? iFrame;

  /// 缓存
  final bool? cache;

  /// 隐藏
  final bool? hidden;

  /// 父级菜单ID
  final int? pid;

  CreateUpdateMenuDto({
    this.id,
    this.type,
    this.permission,
    required this.title,
    this.name,
    this.component,
    this.sort,
    this.icon,
    this.path,
    this.iFrame,
    this.cache,
    this.hidden,
    this.pid,
  });

  factory CreateUpdateMenuDto.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateMenuDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUpdateMenuDtoToJson(this);

  /// 提供一个复制方法，用于创建CreateUpdateMenuDto对象的修改副本
  CreateUpdateMenuDto copyWith({
    int? id,
    int? type,
    String? permission,
    String? title,
    String? name,
    String? component,
    int? sort,
    String? icon,
    String? path,
    bool? iFrame,
    bool? cache,
    bool? hidden,
    int? pid,
  }) {
    return CreateUpdateMenuDto(
      id: id ?? this.id,
      type: type ?? this.type,
      permission: permission ?? this.permission,
      title: title ?? this.title,
      name: name ?? this.name,
      component: component ?? this.component,
      sort: sort ?? this.sort,
      icon: icon ?? this.icon,
      path: path ?? this.path,
      iFrame: iFrame ?? this.iFrame,
      cache: cache ?? this.cache,
      hidden: hidden ?? this.hidden,
      pid: pid ?? this.pid,
    );
  }
}
