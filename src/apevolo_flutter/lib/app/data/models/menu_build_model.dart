class MenuBuild {
  Meta? meta;
  String? name;
  String? path;
  bool? hidden;
  String? redirect;
  String? component;
  bool? alwaysShow;
  List<Children>? children;

  MenuBuild(
      {this.meta,
      this.name,
      this.path,
      this.hidden,
      this.redirect,
      this.component,
      this.alwaysShow,
      this.children});

  MenuBuild.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta?.fromJson(json['meta']) : null;
    name = json['name'];
    path = json['path'];
    hidden = json['hidden'];
    redirect = json['redirect'];
    component = json['component'];
    alwaysShow = json['alwaysShow'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children?.add(Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta?.toJson();
    }
    data['name'] = name;
    data['path'] = path;
    data['hidden'] = hidden;
    data['redirect'] = redirect;
    data['component'] = component;
    data['alwaysShow'] = alwaysShow;
    if (children != null) {
      data['children'] = children?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  String? title;
  String? icon;
  bool? noCache;

  Meta({this.title, this.icon, this.noCache});

  Meta.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    noCache = json['noCache'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['icon'] = icon;
    data['noCache'] = noCache;
    return data;
  }
}

class Children {
  Meta? meta;
  String? name;
  String? path;
  bool? hidden;
  String? component;
  bool? alwaysShow;

  Children(
      {this.meta,
      this.name,
      this.path,
      this.hidden,
      this.component,
      this.alwaysShow});

  Children.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta?.fromJson(json['meta']) : null;
    name = json['name'];
    path = json['path'];
    hidden = json['hidden'];
    component = json['component'];
    alwaysShow = json['alwaysShow'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta?.toJson();
    }
    data['name'] = name;
    data['path'] = path;
    data['hidden'] = hidden;
    data['component'] = component;
    data['alwaysShow'] = alwaysShow;
    return data;
  }
}
