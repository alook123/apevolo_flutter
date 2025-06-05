class SearchFilterModel<T> {
  ///用于记录搜索条件查询的key
  String? key;

  ///查询条件的名称
  String? name;

  ///查询条件的值
  T? value;

  SearchFilterModel({this.key, this.name, this.value});

  SearchFilterModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}
