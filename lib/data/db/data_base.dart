import 'package:equatable/equatable.dart';
import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IVDataBase {
  IVDataBase(this.name);
  final String name;
  late Box _box;
  Future init() async {
    _box = await Hive.openBox(name);
  }

  Future updateStock<T extends DataBaseModelMixin>(T model) {
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

  Stream<IVDataBaseEvent> get stream => _box.watch().map<IVDataBaseEvent>(
        (event) {
          return IVDataBaseEvent<dynamic>(
            event.deleted,
            event.key,
            event.value,
          );
        },
      );

  Future removeStock(String stockIndex) {
    return _box.delete(stockIndex);
  }
}

class IVDataBaseEvent<T> extends Equatable {
  const IVDataBaseEvent(
    this.deleted,
    this.key,
    this.data,
  );
  final bool deleted;
  final String key;
  final T? data;

  @override
  List<Object?> get props => [
        deleted,
        data,
      ];
}
