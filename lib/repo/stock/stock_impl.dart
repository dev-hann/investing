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
  Stream watchListStream() {
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
  Future request20YTreasury({
    required String fromDate,
    required String toDate,
  }) async {
    final res = await service.request20YTreasury(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future request2YTreasury({
    required String fromDate,
    required String toDate,
  }) async {
    final res = await service.request2YTreasury(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestCopper({
    required String fromDate,
    required String toDate,
  }) async {
    final res = await service.requestCopper(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestCrudeOil({
    required String fromDate,
    required String toDate,
  }) async {
    final res = await service.requestCrudeOil(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestGold({
    required String fromDate,
    required String toDate,
  }) async {
    final res = await service.requestGold(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestNaturalGas({
    required String fromDate,
    required String toDate,
  }) async {
    final res = await service.requestNaturalGas(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestNasdaqIndex({
    required String? fromDate,
    required String? toDate,
  }) async {
    final res = await service.requestNasdaqIndex(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestSnpIndex({
    required String? fromDate,
    required String? toDate,
  }) async {
    final res = await service.requestSnpIndex(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestDowIndex({
    required String? fromDate,
    required String? toDate,
  }) async {
    final res = await service.requestDowIndex(
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }

  @override
  Future requestIndex({
    required String symbol,
    required String assetClass,
    required String? fromDate,
    required String? toDate,
  }) async {
    final res = await service.requestStock(
      symbol: symbol,
      assetClass: assetClass,
      fromDate: fromDate,
      toDate: toDate,
    );
    return res.data;
  }
}
