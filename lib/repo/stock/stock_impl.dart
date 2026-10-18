part of 'stock_repo.dart';

class StockImpl extends StockRepo {
  final StockService service = StockService();
  final IVDataBase favoriteDB = IVDataBase('Favorite');

  List<Stock> _loadFavoriteList() {
    return favoriteDB.loadStockList().map(Stock.fromMap).toList();
  }

  @override
  Future<void> init() async {
    await favoriteDB.init();
    return super.init();
  }

  @override
  Stream<List<Stock>> favoriteListStream() {
    return favoriteDB.stream.map((event) => _loadFavoriteList());
  }

  @override
  List<Stock> loadStockList() {
    return _loadFavoriteList();
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
  Future<List<Stock>> searchStock(String query) async {
    final res = await service.searchStock(query);
    final data = res.data as Map<String, dynamic>;
    final symbolData =
        (data['data'] as Map<String, dynamic>)['symbol']
            as Map<String, dynamic>;
    final rows = List<Map<String, dynamic>>.from(
      symbolData['value'] as List<dynamic>,
    );
    final searchedList = <Stock>[];
    for (final row in rows) {
      final item = Stock(
        symbol: (row['symbol'] as List<dynamic>).first as String,
        name: (row['name'] as List<dynamic>).first as String,
        asset: row['asset'] as String,
      );
      if (!searchedList.map((e) => e.symbol).contains(item.symbol)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  @override
  Future<List<Stock>> requestStockList(List<Stock> list) async {
    if (list.isEmpty) {
      return [];
    }
    final symbolList = list
        .map((stock) => '${stock.symbol}|${stock.asset}')
        .toList();
    final res = await service.requestStockList(symbolList);
    final dataList = List<Map<String, dynamic>>.from(
      ((res.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>)['records']
          as List<dynamic>,
    );
    final stockList = <Stock>[];
    for (int index = 0; index < list.length; ++index) {
      final stock = list[index];
      final data = dataList[index];
      stockList.add(
        stock.copyWith(
          lastSalePrice: IVNumberFormat(data['lastSale'] as String?).toDouble(),
          netChange: IVNumberFormat(data['change'] as String?).toDouble(),
          percentChange: IVNumberFormat(data['pctChange'] as String?)
              .toDouble(),
        ),
      );
    }
    return stockList;
  }

  @override
  Future<StockDividend> requestStockDividend({
    required String symbol,
    required String asset,
  }) async {
    final res = await service.requestStockDividend(
      symbol: symbol,
      asset: asset,
    );
    final data = res.data as Map<String, dynamic>;
    return StockDividend.fromMap(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StockFinancial> requestStockFinancial({
    required String symbol,
    required int typeIndex,
  }) async {
    final res = await service.requestStockFinancial(
      symbol: symbol,
      typeIndex: typeIndex,
    );
    final data = res.data as Map<String, dynamic>;
    return StockFinancial.fromMap(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StockChart> requestStockChart({
    required String symbol,
    required String asset,
    required IVDateTimeRange? dateTimeRange,
  }) async {
    final res = await service.requestStockChart(
      symbol: symbol,
      asset: asset,
      fromDate: IVDateTimeFormat(dateTimeRange?.begin).dateTimeFormat(),
      toDate: IVDateTimeFormat(dateTimeRange?.end).dateTimeFormat(),
    );
    final data = res.data as Map<String, dynamic>;
    return StockChart.fromMap(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StockCompany> requestStockCompany(String symbol) async {
    final res = await service.requestStockCompany(symbol);
    final data = res.data as Map<String, dynamic>;
    return StockCompany.fromMap(data['data'] as Map<String, dynamic>);
  }
}
