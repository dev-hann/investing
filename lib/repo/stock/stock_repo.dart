library stock_repo;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/repo/repo.dart';

part './stock_impl.dart';

abstract class StockRepo extends Repo {
  Stream<BoxEvent> watchListStream();
  List loadStockList();
  Future updateStock<T extends DataBaseModelMixin>(T data);
  Future removeStock(String index);
  Future<List> searchStock(String query);

  Future<dynamic> requestStockWithChart({
    required String symbol,
    required String asset,
    required String? fromDate,
    required String? toDate,
  });

  Future<dynamic> requestStock({
    required String symbol,
    required String asset,
  });
}
