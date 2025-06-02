import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'menu_build_model.freezed.dart';
part 'menu_build_model.g.dart';

/// 菜单构建模型
///
/// 用于前端构建路由和菜单树的数据结构
@freezed
abstract class MenuBuild with _$MenuBuild {
  const factory MenuBuild({
    /// 菜单元数据，包含标题、图标等信息
    Meta? meta,

    /// 菜单名称，用于路由识别
    String? name,

    /// 菜单路径，如'/system'、'/permission'等
    String? path,

    /// 是否隐藏菜单
    bool? hidden,

    /// 重定向路径，如'noredirect'表示不重定向
    String? redirect,

    /// 组件路径，如'Layout'表示使用布局组件
    String? component,

    /// 是否总是显示，即使只有一个子菜单
    bool? alwaysShow,

    /// 子菜单列表
    List<ChildrenMenu>? children,

    /// 是否展开菜单（前端UI状态）
    bool? expanded,
  }) = _MenuBuild;

  factory MenuBuild.fromJson(Map<String, dynamic> json) =>
      _$MenuBuildFromJson(json);
}

/// 菜单元数据模型
///
/// 包含菜单的显示信息，如标题、图标等
@freezed
abstract class Meta with _$Meta {
  const factory Meta({
    /// 菜单标题，显示在UI上的名称
    String? title,

    /// 菜单图标，如'system'、'permission'等
    String? icon,

    /// 是否不缓存该路由页面
    bool? noCache,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

/// 子菜单模型
///
/// 表示菜单的子项，包含完整的菜单信息
@freezed
abstract class ChildrenMenu with _$ChildrenMenu {
  const factory ChildrenMenu({
    /// 菜单元数据，包含标题、图标等信息
    Meta? meta,

    /// 菜单名称，用于路由识别，如'User'、'Role'等
    String? name,

    /// 菜单路径，如'user'、'role'等，与父路径组合构成完整路径
    String? path,

    /// 是否隐藏菜单
    bool? hidden,

    /// 组件路径，如'permission/user/index'，指向实际组件位置
    String? component,

    /// 是否总是显示，即使只有一个子菜单
    bool? alwaysShow,

    /// 是否选中状态（前端UI状态）
    bool? selected,

    /// 页签标记，用于多标签页切换
    String? tag,
  }) = _ChildrenMenu;

  factory ChildrenMenu.fromJson(Map<String, dynamic> json) =>
      _$ChildrenMenuFromJson(json);
}
