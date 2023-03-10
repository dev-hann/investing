import 'package:dividends_manager/data/db/data_base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  DataBase(this.name);
  final String name;
  late Box _box;
  Future init() async {
    _box = await Hive.openBox(name);
  }

  Future updateStock(DataBaseModel model) {
    return _box.put(model.index, model.toMap());
  }

  List<Map<String, dynamic>> loadStockList() {
    return _box.values
        .toList()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  dynamic loadStock(String index) {
    return _box.get(index);
  }

  Future clear() {
    return _box.clear();
  }

  Stream<BoxEvent> get stream => _box.watch();

  Future removeStock(String stockIndex) {
    return _box.delete(stockIndex);
  }
}
