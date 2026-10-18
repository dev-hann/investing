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
  Future<dynamic> requestMarketData() async {
    final res = await service.requestMarketData();
    return (res.data as Map<String, dynamic>)['children'];
  }

  @override
  Future<dynamic> requestMarketPercentData() async {
    final res = await service.requestMarketPercentData();
    return (res.data as Map<String, dynamic>)['nodes'];
  }

  @override
  Future<dynamic> requestChartData(List<String> symbolList) async {
    final res = await service.requestChartData(symbolList);
    return res.data;
  }

  @override
  Future<dynamic> requestMarketStatus() async {
    final res = await service.requestMarketStatus();
    return res.data;
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
