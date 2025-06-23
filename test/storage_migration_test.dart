import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apevolo_flutter/shared/storage/shared_prefs_storage_service.dart';

void main() {
  group('存储服务迁移测试', () {
    late SharedPrefsStorageService storageService;

    setUp(() async {
      // 使用 SharedPreferences 的 setMockInitialValues 设置测试环境
      SharedPreferences.setMockInitialValues({});

      storageService = SharedPrefsStorageService();
      await storageService.init();
    });

    test('测试 SharedPrefsStorageService 基础功能', () async {
      // 测试字符串存储
      await storageService.setString('test_key', 'test_value');
      expect(storageService.getString('test_key'), equals('test_value'));

      // 测试布尔值存储
      await storageService.setBool('bool_key', true);
      expect(storageService.getBool('bool_key'), equals(true));

      // 测试整数存储
      await storageService.setInt('int_key', 42);
      expect(storageService.getInt('int_key'), equals(42));

      // 测试删除
      await storageService.remove('test_key');
      expect(storageService.getString('test_key'), isNull);
    });

    test('测试对象存储功能', () async {
      final testData = TestModel(name: 'John', age: 30);

      // 存储对象
      await storageService.saveObject('test_object', testData);

      // 读取对象
      final retrievedData =
          storageService.getObject('test_object', TestModel.fromJson);

      expect(retrievedData, isNotNull);
      expect(retrievedData!.name, equals('John'));
      expect(retrievedData.age, equals(30));
    });

    test('测试列表存储功能', () async {
      final testList = [
        TestModel(name: 'John', age: 30),
        TestModel(name: 'Jane', age: 25),
      ];

      // 存储列表
      await storageService.saveList('test_list', testList);

      // 读取列表
      final retrievedList =
          storageService.getList('test_list', TestModel.fromJson);

      expect(retrievedList?.length, equals(2));
      expect(retrievedList?[0].name, equals('John'));
      expect(retrievedList?[1].name, equals('Jane'));
    });

    test('测试清空功能', () async {
      // 添加一些数据
      await storageService.setString('key1', 'value1');
      await storageService.setString('key2', 'value2');

      // 清空所有数据
      await storageService.clear();

      expect(storageService.getString('key1'), isNull);
      expect(storageService.getString('key2'), isNull);
    });
  });
}

// 测试用的简单模型类
class TestModel {
  final String name;
  final int age;

  TestModel({required this.name, required this.age});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

  static TestModel fromJson(Map<String, dynamic> json) {
    return TestModel(
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestModel && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
