import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'id_collection.g.dart';
part 'id_collection.freezed.dart';

/// 通用ID集合模型
///
/// 用于传递多个ID的场景，例如批量删除操作
@freezed
abstract class IdCollection with _$IdCollection {
  const factory IdCollection({
    /// ID集合
    required List<int> idArray,
  }) = _IdCollection;

  factory IdCollection.fromJson(Map<String, dynamic> json) =>
      _$IdCollectionFromJson(json);
}
