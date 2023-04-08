import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/index.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/date_time_format.dart';

class StockUseCase extends UseCase<StockRepo> {
  StockUseCase(super.repo);

  Stream watchListStream() {
    return repo.watchListStream();
  }

  List<Stock> loadStockList() {
    final list = repo.loadStockList().map((e) => Stock.fromMap(e)).toList();
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
      final item = Stock.dto(list[index]);
      if (!searchedList.contains(item)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  Future<Index> requestIndex(IndexType type) {
    switch (type) {
      case IndexType.nasdaq:
        return requestDowIndex();
      case IndexType.snp500:
        return requestSnpIndex();
      case IndexType.dow:
        return requestDowIndex();
      case IndexType.treasury2Year:
        return request2YTreasuryIndex();
      case IndexType.treasury20Year:
        return request20YTreasuryIndex();
      case IndexType.oil:
        return requestOilIndex();
      case IndexType.gold:
        return requestGoldIndex();
      case IndexType.copper:
        return requestCopperIndex();
      case IndexType.gas:
        return requestNaturalGasIndex();
    }
  }

  Future<Index> requestDowIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    if (dateTimeRange == null) {
      return Index.fromMap(
        await repo.requestDowIndex(fromDate: null, toDate: null),
      );
    }
    return Index.fromMap(
      await repo.requestDowIndex(
        fromDate: IVDateTimeFormat(dateTimeRange.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(dateTimeRange.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> requestSnpIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    if (dateTimeRange == null) {
      return Index.fromMap(
        await repo.requestSnpIndex(fromDate: null, toDate: null),
      );
    }
    return Index.fromMap(
      await repo.requestSnpIndex(
        fromDate: IVDateTimeFormat(dateTimeRange.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(dateTimeRange.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> requestNasdaqIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    if (dateTimeRange == null) {
      return Index.fromMap(
        await repo.requestNasdaqIndex(fromDate: null, toDate: null),
      );
    }
    return Index.fromMap(
      await repo.requestNasdaqIndex(
        fromDate: IVDateTimeFormat(dateTimeRange.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(dateTimeRange.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> request2YTreasuryIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    final range = dateTimeRange ?? DateTimeRange.beforeMonth(1);
    return Index.fromMap(
      await repo.request2YTreasury(
        fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> request20YTreasuryIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    final range = dateTimeRange ?? DateTimeRange.beforeMonth(1);
    return Index.fromMap(
      await repo.request20YTreasury(
        fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> requestGoldIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    final range = dateTimeRange ?? DateTimeRange.beforeMonth(1);
    return Index.fromMap(
      await repo.requestGold(
        fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> requestCopperIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    final range = dateTimeRange ?? DateTimeRange.beforeMonth(1);
    return Index.fromMap(
      await repo.requestCopper(
        fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> requestOilIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    final range = dateTimeRange ?? DateTimeRange.beforeMonth(1);
    return Index.fromMap(
      await repo.requestCrudeOil(
        fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
      ),
    );
  }

  Future<Index> requestNaturalGasIndex({
    DateTimeRange? dateTimeRange,
  }) async {
    final range = dateTimeRange ?? DateTimeRange.beforeMonth(1);
    return Index.fromMap(
      await repo.requestNaturalGas(
        fromDate: IVDateTimeFormat(range.begin).dateTimeFormat(),
        toDate: IVDateTimeFormat(range.end).dateTimeFormat(),
      ),
    );
  }
}
