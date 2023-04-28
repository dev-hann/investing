part of market_repo;

class MarketImpl extends MarketRepo {
  final MarketService service = MarketService();

  @override
  Future requestMarketData() async {
    final res = await service.requestMarketData();
    return res.data["children"];
  }

  @override
  Future requestMarketPercentData() async {
    final res = await service.requestMarkePercenttData();
    return res.data["nodes"];
  }

  @override
  Future requestMarketPercentRealTimeData(List<String> symbolList) async {
    final res = await service.requestStockList(symbolList);
    return res.data;
  }

  @override
  Future requestChartData(List<String> symbolList) async {
    final res = await service.requestChartData(symbolList);
    return res.data;
  }
}
