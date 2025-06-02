import 'package:hive_flutter/hive_flutter.dart';
import 'hive_registry.dart';

class HiveStorageService {
  final Map<String, Box<dynamic>> _boxes = {};

  Future<void> init() async {
    await Hive.initFlutter();
    HiveRegistry.registerAdapters();
    await openBox('userData');
    await openBox('settings');
  }

  Future<Box<dynamic>> openBox(String name) async {
    if (!_boxes.containsKey(name)) {
      _boxes[name] = await Hive.openBox(name);
    }
    return _boxes[name]!;
  }

  T? read<T>(String boxName, String key) {
    final box = _boxes[boxName];
    return box?.get(key) as T?;
  }

  Future<void> write<T>(String boxName, String key, T value) async {
    final box = _boxes[boxName];
    await box?.put(key, value);
  }

  Future<void> delete(String boxName, String key) async {
    final box = _boxes[boxName];
    await box?.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = _boxes[boxName];
    await box?.clear();
  }

  Box<dynamic>? getBox(String boxName) {
    return _boxes[boxName];
  }
}
