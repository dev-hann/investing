import 'package:hive_flutter/hive_flutter.dart';

class IVDataBase {
  IVDataBase(this.name);
  final String name;
  late Box _box;
  Future init() async {
    _box = await Hive.openBox(name);
  }

  Future updateStock({
    required String symbol,
    required Map<String, dynamic> data,
  }) {
    return _box.put(symbol, data);
  }

  List<dynamic> loadStockList() {
    return _box.values.toList();
  }

  dynamic loadStock(String symbol) {
    return _box.get(symbol);
  }

  Future clear() {
    return _box.clear();
  }

  Stream get stream => _box.watch();

  Future removeStock(String symbol) {
    return _box.delete(symbol);
  }
}
