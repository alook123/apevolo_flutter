import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'menu_model.freezed.dart';
part 'menu_model.g.dart';

/// 菜单视图对象
@freezed
abstract class MenuVo with _$MenuVo {
  const factory MenuVo({
    /// 菜单ID
    int? id,

    /// 菜单类型(0:目录 1:菜单 2:按钮)
    int? type,

    /// 权限标识
    String? permission,

    /// 菜单标题
    String? title,

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

    /// 父级菜单名称
    String? pidName,

    /// 子菜单
    List<MenuVo>? children,

    /// 创建时间
    DateTime? createTime,

    /// 更新时间
    DateTime? updateTime,
  }) = _MenuVo;

  factory MenuVo.fromJson(Map<String, dynamic> json) => _$MenuVoFromJson(json);
}
