part of news_repo;

class NewsImpl extends NewsRepo {
  final NewsService service = NewsService();

  @override
  Future requestNewsList(int page) async {
    final res = await service.requestLatestNewsList(page);
    return res["data"]["rows"];
  }

  @override
  Future<List> searchNewsList(String query) async {
    final res = await service.searchNewsList(query);
    return List.from(res["data"]["news"]["value"]);
  }

  @override
  Future searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
  }) async {
    final res = await service.searchStockNewsList(
      symbol: symbol,
      asset: asset,
      page: page,
      stride: 20,
    );
    return res.data["data"]["rows"];
  }
}
