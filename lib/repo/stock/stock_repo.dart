library stock_repo;

import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/repo/repo.dart';
import 'package:investing/util/date_time_format.dart';
part './stock_impl.dart';

abstract class StockRepo extends Repo {
  Stream<IVDataBaseEvent> favoriteStream();
  List loadStockList();
  Future updateStock<T extends DataBaseModelMixin>(T data);
  Future removeStock(String index);
  Future<List> searchStock(String query);

  Future<dynamic> requestStock({
    required String symbol,
    required String asset,
  });

  Future<dynamic> requestMarketStatus();

  Future<dynamic> requestStockList(List<String> symbolList);

  Future<dynamic> requestStockDividend({
    required String symbol,
    required String asset,
  });
  Future<dynamic> requestStockFinancial({
    required String symbol,
    required int typeIndex,
  });

  Future<dynamic> requestStockChart({
    required String symbol,
    required String asset,
    required IVDateTimeRange? dateTimeRange,
  });
}
