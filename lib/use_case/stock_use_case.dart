import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/number_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream<IVDataBaseEvent<Stock>> favoriteStream() {
    return repo.favoriteStream().map((event) {
      final data = event.data;
      return IVDataBaseEvent(
        event.deleted,
        event.key,
        data == null
            ? null
            : Stock(
                name: data["name"],
                symbol: data["symbol"],
                asset: data["asset"],
              ),
      );
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
          ),
        )
        .toList();
    list.sort();
    return list;
  }

  Future updateStock(Stock data) {
    return repo.updateStock(data);
  }

  Future removeStock(String index) {
    return repo.removeStock(index);
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
      if (!searchedList.contains(item)) {
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
    required IVDateTimeRange dateTimeRange,
  }) async {
    final res = await repo.requestStockChart(
      symbol: symbol,
      asset: asset,
      dateTimeRange: dateTimeRange.inDays == 1 ? null : dateTimeRange,
    );
    return StockChart.fromMap(res["data"]);
  }

  Future<MarketStatus> requestMarketStatus() async {
    final res = await repo.requestMarketStatus();
    return MarketStatus.fromMap(res);
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
    return List.from(res["data"]["records"]).map((data) {
      return Stock.fromMap(data);
    }).toList();
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
}
