import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/model/stock_dividend.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/date_time_format.dart';
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

  Future<StockDetail> requestStockDetail({
    required StockDetail stockDetail,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    final res = await await repo.requestStockWithChart(
      symbol: stockDetail.symbol,
      asset: stockDetail.asset,
      fromDate: IVDateTimeFormat(dateTimeRange?.begin).dateTimeFormat(),
      toDate: IVDateTimeFormat(dateTimeRange?.end).dateTimeFormat(),
    );
    final data = Map<String, dynamic>.from(res)["data"];
    return stockDetail.copyWith(
      lastSalePrice: IVNumberFormat(data["lastSalePrice"]).toDouble(),
      netChange: IVNumberFormat(data["netChange"]).toDouble(),
      percentChange: IVNumberFormat(data["percentageChange"]).toDouble(),
      priceChartList:
          List.from(data["chart"]).map((e) => IVChart.fromMap(e)).toList(),
      volumeChartList: List.from(data["volumeChart"] ?? [])
          .map((e) => IVChart.fromMap(e))
          .toList(),
    );
  }

  Future<MarketStatus> requestMarketStatus() async {
    final res = await repo.requestMarketStatus();
    return MarketStatus.fromMap(res);
  }

  Future<List<Stock>> requestStockList(List<Stock> list) async {
    final symbolList = list.map((e) {
      final symbol = e.symbol;
      final asset = e.asset;
      return "$symbol|$asset";
    }).toList();
    final res = await repo.requestStockList(symbolList);
    return List.from(res["data"]["records"]).map((data) {
      final ticker = List.from(data["ticker"]);
      return Stock(
        symbol: ticker.first,
        name: ticker.last,
        asset: data["assetclass"],
        lastSalePrice: IVNumberFormat(data["lastSale"]).toDouble(),
        netChange: IVNumberFormat(data["change"]).toDouble(),
        percentChange: IVNumberFormat(data["pctChange"]).toDouble(),
      );
    }).toList();
  }

  Future<StockDividend?> requestStockDividend(Stock stock) async {
    // TODO: fix enum type
    if (stock.asset.toLowerCase() == "index") {
      return null;
    }
    final res = await repo.requestStockDividend(
      symbol: stock.symbol,
      asset: stock.asset,
    );
    return StockDividend.fromMap(res["data"]);
  }
}
