part of 'market_repo.dart';

class MarketImpl extends MarketRepo {
  final MarketService service = MarketService();

  @override
  Future<dynamic> requestMarketData() async {
    final res = await service.requestMarketData();
    return (res.data as Map<String, dynamic>)['children'];
  }

  @override
  Future<dynamic> requestMarketPercentData() async {
    final res = await service.requestMarkePercenttData();
    return (res.data as Map<String, dynamic>)['nodes'];
  }

  @override
  Future<dynamic> requestMarketPercentRealTimeData(
    List<String> symbolList,
  ) async {
    final res = await service.requestStockList(symbolList);
    return res.data;
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
}
