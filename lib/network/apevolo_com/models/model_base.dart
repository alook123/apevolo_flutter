abstract class ModelBase {
  ModelBase();
  Map<String, dynamic> toJson();

  ModelBase.fromJson(Map<String, dynamic> json);
}
