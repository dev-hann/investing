import 'package:hive_flutter/hive_flutter.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/date_time_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream<BoxEvent> watchListStream() {
    return repo.watchListStream();
  }

  List<Stock> loadStockList() {
    final list = repo.loadStockList().map((e) => Stock.fromDB(e)).toList();
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
      final item = Stock.fromSearch(list[index]);
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
    return stock.fromStock(
      await repo.requestStock(
        symbol: stock.symbol,
        asset: stock.asset,
      ),
    );
  }

  Future<Stock> requestStockWithChart({
    required Stock stock,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    return stock.fromStockWithChart(
      await repo.requestStockWithChart(
        symbol: stock.symbol,
        asset: stock.asset,
        fromDate: IVDateTimeFormat(dateTimeRange?.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(dateTimeRange?.end).dateTimeFormat(),
      ),
    );
  }

  Future<MarketStatus> requestMarketStatus() async {
    final res = await repo.requestMarketStatus();
    return MarketStatus.fromMap(res);
  }
}
