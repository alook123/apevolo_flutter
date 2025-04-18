class QueryRequestBase {
  List<DateTime>? createTime;
  int? pageIndex;
  int? pageSize;
  List<String>? sortFields;
  int? totalElements;
  QueryRequestBase({
    this.createTime,
    this.pageIndex,
    this.pageSize,
    this.sortFields,
    this.totalElements,
  });

  QueryRequestBase.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'] != null
        ? List<DateTime>.from(json['createTime'].map((x) => DateTime.parse(x)))
        : null;
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    sortFields = json['sortFields'] != null
        ? List<String>.from(json['sortFields'].map((x) => x.toString()))
        : null;
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createTime'] = createTime;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['sortFields'] = sortFields;
    data['totalElements'] = totalElements;
    return data;
  }
}
