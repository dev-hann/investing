part of market_repo;

class MarketImpl extends MarketRepo {
  final MarketService service = MarketService();

  @override
  Future requestMarketData() async {
    final res = await service.requestMarketData();
    return res.data["children"];
  }
}
