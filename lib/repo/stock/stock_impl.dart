part of stock_repo;

class StockImpl extends StockRepo {
  final StockService service = StockService();

  final DataBase watchListDB = DataBase("WatchList");

  @override
  Future init() async {
    await watchListDB.init();
    return super.init();
  }

  @override
  Stream<BoxEvent> watchListStream() {
    return watchListDB.stream;
  }

  @override
  List loadStockList() {
    return watchListDB.loadStockList();
  }

  @override
  Future removeStock(String index) async {
    return watchListDB.removeStock(index);
  }

  @override
  Future updateStock<T extends DataBaseModelMixin>(T data) async {
    return watchListDB.updateStock(data);
  }

  @override
  Future<List> searchStock(String query) async {
    return service.searchStock(query);
  }

  @override
  Future requestStockWithChart({
    required String symbol,
    required String asset,
    required String? fromDate,
    required String? toDate,
  }) async {
    final res = await service.requestStockWithChart(
      symbol: symbol,
      assetClass: asset,
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestStock({
    required String symbol,
    required String asset,
  }) async {
    final res = await service.requestStock(
      symbol: symbol,
      assetClass: asset,
    );
    return res.data;
  }
}
