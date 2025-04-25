import 'package:json_annotation/json_annotation.dart';

part 'menu_build_model.g.dart';

@JsonSerializable()
class MenuBuild {
  Meta? meta;
  String? name;
  String? path;
  bool? hidden;
  String? redirect;
  String? component;
  bool? alwaysShow;
  List<ChildrenMenu>? children;
  bool? expanded;

  MenuBuild(
      {this.meta,
      this.name,
      this.path,
      this.hidden,
      this.redirect,
      this.component,
      this.alwaysShow,
      this.children,
      this.expanded});

  factory MenuBuild.fromJson(Map<String, dynamic> json) =>
      _$MenuBuildFromJson(json);
  Map<String, dynamic> toJson() => _$MenuBuildToJson(this);
}

@JsonSerializable()
class Meta {
  String? title;
  String? icon;
  bool? noCache;

  Meta({this.title, this.icon, this.noCache});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class ChildrenMenu {
  Meta? meta;
  String? name;
  String? path;
  bool? hidden;
  String? component;
  bool? alwaysShow;
  bool? selected;
  String? tag;

  ChildrenMenu(
      {this.meta,
      this.name,
      this.path,
      this.hidden,
      this.component,
      this.alwaysShow,
      this.selected,
      this.tag});

  factory ChildrenMenu.fromJson(Map<String, dynamic> json) =>
      _$ChildrenMenuFromJson(json);
  Map<String, dynamic> toJson() => _$ChildrenMenuToJson(this);
}
