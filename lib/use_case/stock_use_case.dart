import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/index.dart';
import 'package:investing/model/ticker.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/date_time_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream watchListStream() {
    return repo.watchListStream();
  }

  List<Ticker> loadStockList() {
    final list = repo.loadStockList().map((e) => Ticker.fromMap(e)).toList();
    list.sort();
    return list;
  }

  Future updateStock(Ticker data) {
    return repo.updateStock(data);
  }

  Future removeStock(String index) {
    return repo.removeStock(index);
  }

  Future<List<Ticker>> searchStock(String query) async {
    final list = await repo.searchStock(query);
    final searchedList = <Ticker>[];
    for (int index = 0; index < list.length; ++index) {
      final item = Ticker.dto(list[index]);
      if (!searchedList.contains(item)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  Future<Index> requestIndex({
    required Index index,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    return index.dto(
      await repo.requestIndex(
        symbol: index.symbol,
        assetClass: index.assetClass,
        fromDate: IVDateTimeFormat(dateTimeRange?.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(dateTimeRange?.end).dateTimeFormat(),
      ),
    );
  }

  // Future<Index> requestDowIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   if (dateTimeRange == null) {
  //     return Index.fromMap(
  //       await repo.requestDowIndex(fromDate: null, toDate: null),
  //     );
  //   }
  //   return Index.fromMap(
  //     await repo.requestDowIndex(
  //       fromDate: IVDateTimeFormat(dateTimeRange.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(dateTimeRange.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> requestSnpIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   if (dateTimeRange == null) {
  //     return Index.fromMap(
  //       await repo.requestSnpIndex(fromDate: null, toDate: null),
  //     );
  //   }
  //   return Index.fromMap(
  //     await repo.requestSnpIndex(
  //       fromDate: IVDateTimeFormat(dateTimeRange.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(dateTimeRange.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> requestNasdaqIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   if (dateTimeRange == null) {
  //     return Index.fromMap(
  //       await repo.requestNasdaqIndex(fromDate: null, toDate: null),
  //     );
  //   }
  //   return Index.fromMap(
  //     await repo.requestNasdaqIndex(
  //       fromDate: IVDateTimeFormat(dateTimeRange.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(dateTimeRange.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> request2YTreasuryIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   final range = dateTimeRange ?? IVDateTimeRange.beforeMonth(1);
  //   return Index.fromMap(
  //     await repo.request2YTreasury(
  //       fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> request20YTreasuryIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   final range = dateTimeRange ?? IVDateTimeRange.beforeMonth(1);
  //   return Index.fromMap(
  //     await repo.request20YTreasury(
  //       fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> requestGoldIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   final range = dateTimeRange ?? IVDateTimeRange.beforeMonth(1);
  //   return Index.fromMap(
  //     await repo.requestGold(
  //       fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> requestCopperIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   final range = dateTimeRange ?? IVDateTimeRange.beforeMonth(1);
  //   return Index.fromMap(
  //     await repo.requestCopper(
  //       fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> requestOilIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   final range = dateTimeRange ?? IVDateTimeRange.beforeMonth(1);
  //   return Index.fromMap(
  //     await repo.requestCrudeOil(
  //       fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
  //     ),
  //   );
  // }

  // Future<Index> requestNaturalGasIndex({
  //   IVDateTimeRange? dateTimeRange,
  // }) async {
  //   final range = dateTimeRange ?? IVDateTimeRange.beforeMonth(1);
  //   return Index.fromMap(
  //     await repo.requestNaturalGas(
  //       fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
  //       toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
  //     ),
  //   );
  // }
}
