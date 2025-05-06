import 'package:json_annotation/json_annotation.dart';

part 'id_collection.g.dart';

/// 通用ID集合模型
///
/// 用于传递多个ID的场景，例如批量删除操作
@JsonSerializable()
class IdCollection {
  /// ID集合
  final List<int> ids;

  IdCollection({required this.ids});

  factory IdCollection.fromJson(Map<String, dynamic> json) =>
      _$IdCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$IdCollectionToJson(this);

  /// 提供一个复制方法，用于创建IdCollection对象的修改副本
  IdCollection copyWith({
    List<int>? ids,
  }) {
    return IdCollection(
      ids: ids ?? this.ids,
    );
  }
}
