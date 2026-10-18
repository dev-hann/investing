part of 'stock_repo.dart';

class StockImpl extends StockRepo {
  final StockService service = StockService();
  final IVDataBase favoriteDB = IVDataBase('Favorite');

  @override
  Future<void> init() async {
    await favoriteDB.init();
    return super.init();
  }

  @override
  Stream<List<dynamic>> favoriteListStream() {
    return favoriteDB.stream.map((event) => favoriteDB.loadStockList());
  }

  @override
  List<dynamic> loadStockList() {
    return favoriteDB.loadStockList();
  }

  @override
  Future<void> removeStock(String index) async {
    return favoriteDB.removeStock(index);
  }

  @override
  Future<void> updateStock({
    required String symbol,
    required Map<String, dynamic> data,
  }) async {
    return favoriteDB.updateStock(symbol: symbol, data: data);
  }

  @override
  Future<List<dynamic>> searchStock(String query) async {
    final res = await service.searchStock(query);
    final data = res.data as Map<String, dynamic>;
    final symbolData =
        (data['data'] as Map<String, dynamic>)['symbol']
            as Map<String, dynamic>;
    return List<dynamic>.from(symbolData['value'] as List<dynamic>);
  }

  @override
  Future<dynamic> requestStock({
    required String symbol,
    required String asset,
  }) async {
    final res = await service.requestStock(symbol: symbol, assetClass: asset);
    return res.data;
  }

  @override
  Future<dynamic> requestStockList(List<String> symbolList) async {
    final res = await service.requestStockList(symbolList);
    return res.data;
  }

  @override
  Future<dynamic> requestStockDividend({
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
  Future<dynamic> requestStockFinancial({
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
  Future<dynamic> requestStockChart({
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
  Future<dynamic> reqeustStockCompany(String symbol) async {
    final res = await service.requestStockCompany(symbol);
    return (res.data as Map<String, dynamic>)['data'];
  }
}
