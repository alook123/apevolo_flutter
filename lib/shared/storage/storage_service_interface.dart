/// 抽象存储服务接口
///
/// 定义统一的存储接口，支持不同的存储实现
/// 目前支持：Hive、SharedPreferences
abstract class StorageServiceInterface {
  /// 保存对象
  Future<void> saveObject<T>(String key, T object);

  /// 获取对象
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);

  /// 保存列表
  Future<void> saveList<T>(String key, List<T> list);

  /// 获取列表
  List<T>? getList<T>(String key, T Function(Map<String, dynamic>) fromJson);

  /// 保存基础类型
  Future<void> setString(String key, String value);
  Future<void> setBool(String key, bool value);
  Future<void> setInt(String key, int value);

  /// 获取基础类型
  String? getString(String key);
  bool getBool(String key);
  int getInt(String key);

  /// 删除和清空
  Future<void> remove(String key);
  Future<void> clear();

  /// 检查键是否存在
  bool containsKey(String key);
}
