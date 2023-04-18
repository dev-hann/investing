import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream<IVDataBaseEvent<Stock>> watchListStream() {
    return repo.watchListStream().map((event) {
      final data = event.data;
      return IVDataBaseEvent(
        event.deleted,
        Stock.empty(
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
          (data) => Stock.empty(
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

      final item = Stock.empty(
        name: List.from(data["name"]).first,
        symbol: List.from(data["symbol"]).first,
        asset: data["asset"],
      );
      if (!searchedList.contains(item)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  Future<Stock> requestStock({
    required Stock stock,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    final res = await repo.requestStock(
      symbol: stock.symbol,
      asset: stock.asset,
    );
    final data = Map<String, dynamic>.from(res)["data"];
    final primaryData = data["primaryData"];
    return stock.copyWith(
      deltaIndicator: primaryData["deltaIndicator"],
      lastSalePrice: IVNumberFormat(primaryData["lastSalePrice"]).toDouble(),
      netChange: primaryData["netChange"],
      percentageChange: primaryData["percentageChange"],
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
    final Map<String, dynamic> data = Map<String, dynamic>.from(res)["data"];
    return stockDetail.copyWith(
      deltaIndicator: data["deltaIndicator"],
      lastSalePrice: IVNumberFormat(data["lastSalePrice"]).toDouble(),
      previousSalePrice: IVNumberFormat(data["previousClose"]).toDouble(),
      netChange: data["netChange"],
      percentageChange: data["percentageChange"],
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
    return [];
    // return List.from(res).map((e) => )
  }
}
