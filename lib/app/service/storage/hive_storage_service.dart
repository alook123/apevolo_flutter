import 'package:hive_flutter/hive_flutter.dart';
import 'package:apevolo_flutter/app/service/storage/hive_registry.dart';

class HiveStorageService {
  final Map<String, Box<dynamic>> _boxes = {};

  // 初始化Hive并注册适配器
  Future<void> init() async {
    await Hive.initFlutter();

    // 注册所有适配器
    HiveRegistry.registerAdapters();

    // 预打开常用的boxes
    await openBox('userData'); // 用户数据
    await openBox('settings'); // 系统设置(默认)
  }

  // 获取或打开一个Box
  Future<Box<dynamic>> openBox(String name) async {
    if (!_boxes.containsKey(name)) {
      _boxes[name] = await Hive.openBox(name);
    }
    return _boxes[name]!;
  }

  // 从指定Box读取数据
  T? read<T>(String boxName, String key) {
    final box = _boxes[boxName];
    return box?.get(key) as T?;
  }

  // 向指定Box写入数据
  Future<void> write<T>(String boxName, String key, T value) async {
    final box = _boxes[boxName];
    await box?.put(key, value);
  }

  // 删除指定Box中的数据
  Future<void> delete(String boxName, String key) async {
    final box = _boxes[boxName];
    await box?.delete(key);
  }

  // 清空指定Box
  Future<void> clear(String boxName) async {
    final box = _boxes[boxName];
    await box?.clear();
  }

  // 获取Box以便直接操作
  Box<dynamic>? getBox(String boxName) {
    return _boxes[boxName];
  }
}
