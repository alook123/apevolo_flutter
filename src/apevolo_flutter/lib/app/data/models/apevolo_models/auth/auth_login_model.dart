class AuthLogin {
  User? user;
  Token? token;

  AuthLogin({this.user, this.token});

  AuthLogin.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User?.fromJson(json['user']) : null;
    token = json['token'] != null ? Token?.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user?.toJson();
    }
    if (token != null) {
      data['token'] = token?.toJson();
    }
    return data;
  }
}

class User {
  UserInfo? user;
  List<String>? roles;
  List<String>? dataScopes;

  User({this.user, this.roles, this.dataScopes});

  User.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserInfo?.fromJson(json['user']) : null;
    roles = json['roles'].cast<String>();
    dataScopes = json['dataScopes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user?.toJson();
    }
    data['roles'] = roles;
    data['dataScopes'] = dataScopes;
    return data;
  }
}

class UserInfo {
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

  UserInfo(
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

  UserInfo.fromJson(Map<String, dynamic> json) {
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

class Token {
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? refreshToken;
  int? refreshTokenExpiresIn;

  Token(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.refreshToken,
      this.refreshTokenExpiresIn});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    refreshTokenExpiresIn = json['refresh_token_expires_in'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    data['token_type'] = tokenType;
    data['refresh_token'] = refreshToken;
    data['refresh_token_expires_in'] = refreshTokenExpiresIn;
    return data;
  }
}
