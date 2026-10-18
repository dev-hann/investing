part of 'market_repo.dart';

class MarketImpl extends MarketRepo {
  MarketImpl() : percentDB = IVDataBase('MarketPercent');

  final MarketService service = MarketService();
  final AlpacaService alpacaService = AlpacaService();
  final IVDataBase percentDB;

  @override
  Future<void> init() async {
    await percentDB.init();
    return super.init();
  }

  @override
  Future<List<MarketData>> requestMarketData() async {
    final res = await service.requestMarketData();
    final children =
        (res.data as Map<String, dynamic>)['children'] as List<dynamic>;
    return children.map(MarketData.fromMap).toList();
  }

  @override
  Future<Map<String, double>> requestMarketPercentData() async {
    final res = await service.requestMarketPercentData();
    final nodes =
        (res.data as Map<String, dynamic>)['nodes'] as Map<dynamic, dynamic>;
    return nodes.map(
      (key, value) => MapEntry(key as String, (value as num).toDouble()),
    );
  }

  @override
  Future<Map<String, List<double>>> requestChartData(
    List<String> symbolList,
  ) async {
    final res = await service.requestChartData(symbolList);
    final data = res.data as Map<dynamic, dynamic>;
    return data.map(
      (key, value) => MapEntry(
        key as String,
        (value as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      ),
    );
  }

  @override
  Future<MarketStatus> requestMarketStatus() async {
    final res = await service.requestMarketStatus();
    return MarketStatus.fromMap(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<Stock>> requestMovers(MarketMoverCategory category) async {
    final res = await service.requestMovers(category);
    final rows =
        (((res.data as Map<String, dynamic>)['data']
                    as Map<String, dynamic>)['rows']
                as List<dynamic>)
            .cast<Map<String, dynamic>>();
    return [
      for (final row in rows)
        Stock(
          symbol: row['symbol'] as String,
          name: row['name'] as String,
          asset: 'stocks',
          lastSalePrice: IVNumberFormat(row['lastsale'] as String?).toDouble(),
          netChange: IVNumberFormat(row['netchange'] as String?).toDouble(),
          percentChange: IVNumberFormat(row['pctchange'] as String?).toDouble(),
        ),
    ];
  }

  @override
  bool get isRealTimeConfigured => alpacaService.isConfigured;

  @override
  Future<Map<String, double>> requestPrevCloses(List<String> symbols) {
    return alpacaService.requestPrevCloses(symbols);
  }

  @override
  Stream<Quote> subscribeQuoteStream(List<String> symbols) async* {
    await for (final data in alpacaService.subscribeQuotes(symbols)) {
      final quote = Quote.tryFromMap(data);
      if (quote != null) {
        yield quote;
      }
    }
  }

  @override
  Map<String, double> loadPercentData() {
    final data = percentDB.read('percent');
    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key as String, (value as num).toDouble()),
      );
    }
    return {};
  }

  @override
  Future<void> savePercentData(Map<String, double> data) {
    return percentDB.put(key: 'percent', value: data);
  }
}
