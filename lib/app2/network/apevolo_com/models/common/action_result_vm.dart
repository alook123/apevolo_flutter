import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_result_vm.g.dart';
part 'action_result_vm.freezed.dart';

/// 通用API响应结果包装类
@Freezed(genericArgumentFactories: true)
abstract class ActionResultVm<T> with _$ActionResultVm<T> {
  const factory ActionResultVm({
    /// 是否成功
    bool? success,

    /// 消息
    String? message,

    /// 错误代码
    int? code,

    /// 返回数据
    T? result,

    /// 时间戳
    int? timestamp,
  }) = _ActionResultVm;

  factory ActionResultVm.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ActionResultVmFromJson(json, fromJsonT);
}
