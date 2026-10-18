import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/number_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream<List<Stock>> favoriteListStream() {
    return repo.favoriteListStream().map((event) {
      return event.map(Stock.fromMap).toList();
    });
  }

  List<Stock> loadStockList() {
    final list =
        List<Map<String, dynamic>>.from(repo.loadStockList())
            .map(
              (data) => Stock(
                name: data['name'] as String,
                symbol: data['symbol'] as String,
                asset: data['asset'] as String,
                order: data['order'] as int?,
              ),
            )
            .toList()
          ..sort();
    return list;
  }

  Future<void> updateStock(Stock stock) {
    return repo.updateStock(symbol: stock.symbol, data: stock.toMap());
  }

  Future<void> removeStock(Stock stock) {
    return repo.removeStock(stock.symbol);
  }

  Future<List<Stock>> searchStock(String query) async {
    final list = await repo.searchStock(query);
    final searchedList = <Stock>[];
    for (int index = 0; index < list.length; ++index) {
      final data = list[index] as Map<String, dynamic>;
      final item = Stock(
        symbol:
            List<dynamic>.from(data['symbol'] as List<dynamic>).first as String,
        name: List<dynamic>.from(data['name'] as List<dynamic>).first as String,
        asset: data['asset'] as String,
      );

      if (!searchedList.map((e) => e.symbol).contains(item.symbol)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  @Deprecated('will be deprecated')
  Future<Stock> requestStock(Stock stock) async {
    final res = await repo.requestStock(
      symbol: stock.symbol,
      asset: stock.asset,
    ) as Map<String, dynamic>;
    final data = res['data'] as Map<String, dynamic>;
    final primaryData = data['primaryData'] as Map<String, dynamic>;
    return stock.copyWith(
      lastSalePrice: IVNumberFormat(primaryData['lastSalePrice'] as String?)
          .toDouble(),
      netChange: IVNumberFormat(primaryData['netChange'] as String?).toDouble(),
      percentChange: IVNumberFormat(primaryData['percentageChange'] as String?)
          .toDouble(),
    );
  }

  Future<StockChart> requestStockChart({
    required String symbol,
    required String asset,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    final res = await repo.requestStockChart(
      symbol: symbol,
      asset: asset,
      dateTimeRange: dateTimeRange,
    ) as Map<String, dynamic>;
    return StockChart.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<List<Stock>> requestStockList(List<Stock> list) async {
    if (list.isEmpty) {
      return [];
    }
    final symbolList = list.map((e) {
      final symbol = e.symbol;
      final asset = e.asset;
      return '$symbol|$asset';
    }).toList();
    final res = await repo.requestStockList(symbolList) as Map<String, dynamic>;
    final dataList = List<Map<String, dynamic>>.from(
      (res['data'] as Map<String, dynamic>)['records'] as List<dynamic>,
    );
    final List<Stock> stockList = [];
    for (int index = 0; index < list.length; ++index) {
      final stock = list[index];
      final data = dataList[index];
      stockList.add(
        stock.copyWith(
          lastSalePrice: IVNumberFormat(data['lastSale'] as String?).toDouble(),
          netChange: IVNumberFormat(data['change'] as String?).toDouble(),
          percentChange: IVNumberFormat(data['pctChange'] as String?)
              .toDouble(),
        ),
      );
    }
    return stockList;
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
      final res = await repo.requestStockDividend(
        symbol: symbol,
        asset: asset,
      ) as Map<String, dynamic>;
      return StockDividend.fromMap(res['data'] as Map<String, dynamic>);
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
      final res = await repo.requestStockFinancial(
        symbol: symbol,
        typeIndex: type.index,
      ) as Map<String, dynamic>;
      return StockFinancial.fromMap(res['data'] as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<StockCompany?> reqeustStockCompany(String symbol) async {
    try {
      final res =
          await repo.reqeustStockCompany(symbol) as Map<String, dynamic>;
      return StockCompany.fromMap(res);
    } catch (e) {
      return null;
    }
  }
}
