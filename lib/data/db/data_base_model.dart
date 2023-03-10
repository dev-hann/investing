abstract class DataBaseModel {
  const DataBaseModel({
    required this.index,
  });
  final String index;

  Map<String, dynamic> toMap();
}
