import 'package:apevolo_flutter/app/data/models/model_base.dart';

class QueryBase<T extends ModelBase> {
  List<T>? content;
  int? totalElements;

  QueryBase({
    this.content,
    this.totalElements,
  });

  QueryBase.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null && json['content'].length > 0) {
      content =
          json['content'].map<T>((e) => e as Map<String, dynamic>).toList();
    } else {
      content = null;
    }
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content;
      //data['content'] = content!.map((e) => e.toJson()).toList();
    }
    data['totalElements'] = totalElements;
    return data;
  }
}
