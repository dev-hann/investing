import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/number_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream<List<Stock>> favoriteListStream() {
    return repo.favoriteListStream().map((event) {
      return event.map((e) => Stock.fromMap(e)).toList();
    });
  }

  List<Stock> loadStockList() {
    final list = repo
        .loadStockList()
        .map(
          (data) => Stock(
            name: data["name"],
            symbol: data["symbol"],
            asset: data["asset"],
            order: data["order"],
          ),
        )
        .toList();
    list.sort();
    return list;
  }

  Future updateStock(Stock stock) {
    return repo.updateStock(
      symbol: stock.symbol,
      data: stock.toMap(),
    );
  }

  Future removeStock(Stock stock) {
    return repo.removeStock(stock.symbol);
  }

  Future<List<Stock>> searchStock(String query) async {
    final list = await repo.searchStock(query);
    final searchedList = <Stock>[];
    for (int index = 0; index < list.length; ++index) {
      final data = list[index];
      final item = Stock(
        symbol: List.from(data["symbol"]).first,
        name: List.from(data["name"]).first,
        asset: data["asset"],
      );

      if (!searchedList.map((e) => e.symbol).contains(item.symbol)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  @Deprecated("will be deprecated")
  Future<Stock> requestStock(Stock stock) async {
    final res = await repo.requestStock(
      symbol: stock.symbol,
      asset: stock.asset,
    );
    final data = Map<String, dynamic>.from(res)["data"];
    final primaryData = data["primaryData"];
    return stock.copyWith(
      lastSalePrice: IVNumberFormat(primaryData["lastSalePrice"]).toDouble(),
      netChange: IVNumberFormat(primaryData["netChange"]).toDouble(),
      percentChange: IVNumberFormat(primaryData["percentageChange"]).toDouble(),
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
    );
    return StockChart.fromMap(res["data"]);
  }

  Future<List<Stock>> requestStockList(List<Stock> list) async {
    if (list.isEmpty) {
      return [];
    }
    final symbolList = list.map((e) {
      final symbol = e.symbol;
      final asset = e.asset;
      return "$symbol|$asset";
    }).toList();
    final res = await repo.requestStockList(symbolList);
    final dataList = List.from(res["data"]["records"]);
    final List<Stock> stockList = [];
    for (int index = 0; index < list.length; ++index) {
      final stock = list[index];
      final data = dataList[index];
      stockList.add(
        stock.copyWith(
          lastSalePrice: IVNumberFormat(data["lastSale"]).toDouble(),
          netChange: IVNumberFormat(data["change"]).toDouble(),
          percentChange: IVNumberFormat(data["pctChange"]).toDouble(),
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
    if (asset.toLowerCase() == "index") {
      return null;
    }
    try {
      final res = await repo.requestStockDividend(
        symbol: symbol,
        asset: asset,
      );
      return StockDividend.fromMap(res["data"]);
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
      );
      return StockFinancial.fromMap(res["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<StockCompany?> reqeustStockCompany(String symbol) async {
    try {
      final res = await repo.reqeustStockCompany(symbol);
      return StockCompany.fromMap(res);
    } catch (e) {
      return null;
    }
  }
}
