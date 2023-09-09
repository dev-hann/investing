part of stock_repo;

class StockImpl extends StockRepo {
  final StockService service = StockService();
  final IVDataBase favoriteDB = IVDataBase("Favorite");

  @override
  Future init() async {
    await favoriteDB.init();
    return super.init();
  }

  @override
  Stream<List<dynamic>> favoriteListStream() {
    return favoriteDB.stream.map((event) => favoriteDB.loadStockList());
  }

  @override
  List loadStockList() {
    return favoriteDB.loadStockList();
  }

  @override
  Future removeStock(String index) async {
    return favoriteDB.removeStock(index);
  }

  @override
  Future updateStock({
    required String symbol,
    required Map<String, dynamic> data,
  }) async {
    return favoriteDB.updateStock(
      symbol: symbol,
      data: data,
    );
  }

  @override
  Future<List> searchStock(String query) async {
    final res = await service.searchStock(query);
    return List.from(res.data["data"]["symbol"]["value"]);
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

  @override
  Future requestStockList(List<String> symbolList) async {
    final res = await service.requestStockList(symbolList);
    return res.data;
  }

  @override
  Future requestStockDividend({
    required String symbol,
    required String asset,
  }) async {
    final res = await service.requestStockDividend(
      symbol: symbol,
      asset: asset,
    );
    return res.data;
  }

  @override
  Future requestStockFinancial({
    required String symbol,
    required int typeIndex,
  }) async {
    final res = await service.requestStockFinancial(
      symbol: symbol,
      typeIndex: typeIndex,
    );
    return res.data;
  }

  @override
  Future requestStockChart({
    required String symbol,
    required String asset,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    final res = await service.requestStockCahrt(
      symbol: symbol,
      asset: asset,
      fromDate: IVDateTimeFormat(dateTimeRange?.begin).dateTimeFormat(),
      toDate: IVDateTimeFormat(dateTimeRange?.end).dateTimeFormat(),
    );
    return res.data;
  }

  @override
  Future reqeustStockCompany(String symbol) async {
    final res = await service.requestStockCompany(symbol);
    return res.data["data"];
  }
}
