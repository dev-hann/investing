import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream<List<Stock>> favoriteListStream() {
    return repo.favoriteListStream().map((list) => list..sort());
  }

  List<Stock> loadStockList() {
    return repo.loadStockList()..sort();
  }

  Future<void> updateStock(Stock stock) {
    return repo.updateStock(symbol: stock.symbol, data: stock.toMap());
  }

  Future<void> removeStock(Stock stock) {
    return repo.removeStock(stock.symbol);
  }

  /// Rewrites the favorite box to match [list] (order + membership).
  Future<void> updateFavoriteList(List<Stock> list) async {
    final current = loadStockList();
    for (final stock in current) {
      if (!list.any((e) => e.isEquals(stock))) {
        await repo.removeStock(stock.symbol);
      }
    }
    for (final stock in list) {
      await repo.updateStock(symbol: stock.symbol, data: stock.toMap());
    }
  }

  Future<List<Stock>> searchStock(String query) {
    return repo.searchStock(query);
  }

  Future<List<Stock>> requestStockList(List<Stock> list) {
    return repo.requestStockList(list);
  }

  Future<StockDividend?> requestStockDividend({
    required String symbol,
    required String asset,
  }) async {
    // TODO: fix enum type
    if (asset.toLowerCase() == 'index') {
      return null;
    }
    try {
      return await repo.requestStockDividend(symbol: symbol, asset: asset);
    } catch (e) {
      // some stock have no dividend
      return null;
    }
  }

  Future<StockFinancial?> requestStockFinancial({
    required String symbol,
    required FinancialType type,
  }) async {
    try {
      return await repo.requestStockFinancial(
        symbol: symbol,
        typeIndex: type.index,
      );
    } catch (e) {
      return null;
    }
  }

  Future<StockCompany?> requestStockCompany(String symbol) async {
    try {
      return await repo.requestStockCompany(symbol);
    } catch (e) {
      return null;
    }
  }

  Future<StockChart> requestStockChart({
    required String symbol,
    required String asset,
    required IVDateTimeRange? dateTimeRange,
  }) {
    return repo.requestStockChart(
      symbol: symbol,
      asset: asset,
      dateTimeRange: dateTimeRange,
    );
  }
}

final stockUseCaseProvider = Provider(
  (ref) => StockUseCase(ref.watch(stockRepoProvider)),
);
