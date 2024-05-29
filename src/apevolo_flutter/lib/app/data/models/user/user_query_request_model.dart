import 'package:apevolo_flutter/app/data/models/query_request_base_model.dart';

class UserQueryRequest extends QueryRequestBase {
  int? id;
  List<int>? deptIds;
  String? keyWords;
  bool? enabled;
  int? deptId;
  UserQueryRequest({
    super.createTime,
    super.pageIndex,
    super.pageSize,
    super.sortFields,
    super.totalElements,
    this.id,
    this.deptIds,
    this.keyWords,
    this.enabled,
    this.deptId,
  });
  UserQueryRequest.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    sortFields = json['sortFields'];
    totalElements = json['totalElements'];
    id = json['id'];
    deptIds = json['deptIds'] != null ? List<int>.from(json['deptIds']) : null;
    keyWords = json['keyWords'];
    enabled = json['enabled'];
    deptId = json['deptId'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['id'] = id;
    data['deptIds'] = deptIds;
    data['keyWords'] = keyWords;
    data['enabled'] = enabled;
    data['deptId'] = deptId;
    return data;
  }
}
