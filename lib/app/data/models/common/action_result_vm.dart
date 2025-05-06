import 'package:json_annotation/json_annotation.dart';

part 'action_result_vm.g.dart';

/// 通用API响应结果包装类
@JsonSerializable(genericArgumentFactories: true)
class ActionResultVm<T> {
  /// 是否成功
  final bool? success;

  /// 消息
  final String? message;

  /// 错误代码
  final int? code;

  /// 返回数据
  final T? result;

  /// 时间戳
  final int? timestamp;

  ActionResultVm({
    this.success,
    this.message,
    this.code,
    this.result,
    this.timestamp,
  });

  factory ActionResultVm.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ActionResultVmFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ActionResultVmToJson(this, toJsonT);

  /// 提供一个复制方法，用于创建ActionResultVm对象的修改副本
  ActionResultVm<T> copyWith({
    bool? success,
    String? message,
    int? code,
    T? result,
    int? timestamp,
  }) {
    return ActionResultVm<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      code: code ?? this.code,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
