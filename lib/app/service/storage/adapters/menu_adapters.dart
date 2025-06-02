import 'package:apevolo_flutter/app/data/models/apevolo_models/menu/menu_build_model.dart';
import 'package:hive/hive.dart';

/// 菜单相关适配器
///
/// 包含与菜单、导航相关的Hive类型适配器
class MenuBuildAdapter extends TypeAdapter<MenuBuild> {
  @override
  final int typeId = 2;

  @override
  MenuBuild read(BinaryReader reader) {
    final map = reader.readMap();
    return MenuBuild.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  void write(BinaryWriter writer, MenuBuild obj) {
    writer.writeMap(obj.toJson());
  }
}

/// 子菜单适配器
class ChildrenMenuAdapter extends TypeAdapter<ChildrenMenu> {
  @override
  final int typeId = 3;

  @override
  ChildrenMenu read(BinaryReader reader) {
    final map = reader.readMap();
    return ChildrenMenu.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  void write(BinaryWriter writer, ChildrenMenu obj) {
    writer.writeMap(obj.toJson());
  }
}
