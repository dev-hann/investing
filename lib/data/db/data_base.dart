import 'package:hive_ce_flutter/hive_flutter.dart';

class IVDataBase {
  IVDataBase(this.name);
  final String name;
  late Box<dynamic> _box;
  Future<void> init() async {
    _box = await Hive.openBox(name);
  }

  Future<void> updateStock({
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

  Future<int> clear() {
    return _box.clear();
  }

  Stream<BoxEvent> get stream => _box.watch();

  Future<void> removeStock(String symbol) {
    return _box.delete(symbol);
  }

  /// Generic key-value access for non-stock boxes (e.g. cached maps).
  Future<void> put({required String key, required Object? value}) {
    return _box.put(key, value);
  }

  dynamic read(String key) {
    return _box.get(key);
  }
}
