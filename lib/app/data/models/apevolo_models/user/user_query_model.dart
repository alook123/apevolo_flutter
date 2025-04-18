import 'package:apevolo_flutter/app/data/models/apevolo_models/model_base.dart';

class UserQuery extends ModelBase {
  List<Content>? content;
  int? totalElements;

  UserQuery({this.content, this.totalElements});

  UserQuery.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content?.add(Content.fromJson(v));
      });
    }
    totalElements = json['totalElements'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content?.map((v) => v.toJson()).toList();
    }
    data['totalElements'] = totalElements;
    return data;
  }
}

class Content {
  String? username;
  String? nickName;
  String? email;
  bool? isAdmin;
  bool? enabled;
  String? password;
  String? deptId;
  String? phone;
  String? avatarPath;
  bool? sex;
  String? gender;
  List<Roles>? roles;
  Dept? dept;
  List<Dept>? jobs;
  String? id;
  String? createBy;
  String? createTime;

  Content(
      {this.username,
      this.nickName,
      this.email,
      this.isAdmin,
      this.enabled,
      this.password,
      this.deptId,
      this.phone,
      this.avatarPath,
      this.sex,
      this.gender,
      this.roles,
      this.dept,
      this.jobs,
      this.id,
      this.createBy,
      this.createTime});

  Content.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    nickName = json['nickName'];
    email = json['email'];
    isAdmin = json['isAdmin'];
    enabled = json['enabled'];
    password = json['password'];
    deptId = json['deptId'];
    phone = json['phone'];
    avatarPath = json['avatarPath'];
    sex = json['sex'];
    gender = json['gender'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles?.add(Roles.fromJson(v));
      });
    }
    dept = json['dept'] != null ? Dept?.fromJson(json['dept']) : null;
    if (json['jobs'] != null) {
      jobs = <Dept>[];
      json['jobs'].forEach((v) {
        jobs?.add(Dept.fromJson(v));
      });
    }
    id = json['id'];
    createBy = json['createBy'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['nickName'] = nickName;
    data['email'] = email;
    data['isAdmin'] = isAdmin;
    data['enabled'] = enabled;
    data['password'] = password;
    data['deptId'] = deptId;
    data['phone'] = phone;
    data['avatarPath'] = avatarPath;
    data['sex'] = sex;
    data['gender'] = gender;
    if (roles != null) {
      data['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    if (dept != null) {
      data['dept'] = dept?.toJson();
    }
    if (jobs != null) {
      data['jobs'] = jobs?.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    return data;
  }
}

class Roles {
  String? id;
  String? name;
  String? permission;
  int? level;
  String? dataScope;

  Roles({this.id, this.name, this.permission, this.level, this.dataScope});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    permission = json['permission'];
    level = json['level'];
    dataScope = json['dataScope'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['permission'] = permission;
    data['level'] = level;
    data['dataScope'] = dataScope;
    return data;
  }
}

class Dept {
  String? id;
  String? name;

  Dept({this.id, this.name});

  Dept.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
