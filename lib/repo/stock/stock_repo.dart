library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/repo/repo.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';
part './stock_impl.dart';

abstract class StockRepo extends Repo {
  Stream<List<Stock>> favoriteListStream();
  List<Stock> loadStockList();
  Future<void> updateStock({
    required String symbol,
    required Map<String, dynamic> data,
  });
  Future<void> removeStock(String symbol);

  Future<List<Stock>> searchStock(String query);

  Future<List<Stock>> requestStockList(List<Stock> list);

  Future<StockDividend> requestStockDividend({
    required String symbol,
    required String asset,
  });
  Future<StockFinancial> requestStockFinancial({
    required String symbol,
    required int typeIndex,
  });

  Future<StockChart> requestStockChart({
    required String symbol,
    required String asset,
    required IVDateTimeRange? dateTimeRange,
  });

  Future<StockCompany> requestStockCompany(String symbol);
}

final stockRepoProvider = Provider<StockRepo>((ref) => StockImpl());
